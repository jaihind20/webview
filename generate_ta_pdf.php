<?php
require_once 'db_connect.php';

// --- Page Protection ---
if (!isset($_SESSION['user_id']) || $_SERVER['REQUEST_METHOD'] !== 'POST') {
    die('Access denied.');
}

// --- Data Retrieval & Sanitization ---
$user_id = $_SESSION['user_id'];
$post_data = $_POST;

$user_stmt = $conn->prepare("
    SELECT u.full_name, r.role_name, s.station_name 
    FROM users u 
    LEFT JOIN roles r ON u.role_id = r.id
    LEFT JOIN stations s ON u.station_id = s.id
    WHERE u.id = ?
");
$user_stmt->bind_param("i", $user_id);
$user_stmt->execute();
$user_db_info = $user_stmt->get_result()->fetch_assoc();
$name_in_hindi = $user_db_info['full_name']; 

// Combine role and station for designation
$designation_with_station = ($user_db_info['role_name'] ?? '') . ' (' . ($user_db_info['station_name'] ?? '') . ')';

$claim_data = [
    'name_english' => $post_data['name_english'] ?? '',
    'name_hindi' => $name_in_hindi,
    'post_name_with_stn' => $post_data['post_name_with_stn'] ?? $designation_with_station,
    'hq' => $post_data['hq'] ?? '',
    'month_year_english' => date('F-Y', strtotime($post_data['month_year'])),
    'month_year_hindi' => date('F-Y', strtotime($post_data['month_year'])),
    'basic_pay' => $post_data['basic_pay'] ?? 0,
    'pay_scale' => $post_data['pay_scale'] ?? '',
    'grade_pay' => $post_data['grade_pay'] ?? 0,
    'pf_number' => $post_data['pf_number'] ?? '',
    'journeys' => $post_data['journeys'] ?? [],
    'total_amount' => (float)($post_data['total_amount'] ?? 0)
];

function numberToWords($number) {
    $fmt = new NumberFormatter('en_IN', NumberFormatter::SPELLOUT);
    return ucwords($fmt->format($number)) . " Only";
}
$claim_data['amount_in_words'] = numberToWords($claim_data['total_amount']);

// --- CORRECT MERGING LOGIC ---
$journeys = $claim_data['journeys'];
$merge_count = 0;
// Iterate backwards to calculate rowspans based ONLY on the merge checkbox
for ($i = count($journeys) - 1; $i >= 0; $i--) {
    // Check if the 'merge' checkbox was ticked for this row
    if (isset($journeys[$i]['merge']) && $journeys[$i]['merge'] === 'on' && $i > 0) {
        $journeys[$i]['is_merged_row'] = true;
        $merge_count++;
    } else {
        $journeys[$i]['merge_span'] = $merge_count + 1;
        $merge_count = 0; 
    }
}


// --- Save Claim to Database ---
$stmt = $conn->prepare("INSERT INTO ta_claims_master (user_id, month_year, basic_pay, pay_scale, grade_pay, pf_number, claim_data, total_amount, amount_in_words) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
$claim_data_json = json_encode($claim_data['journeys']);
$stmt->bind_param("isissisds", $user_id, $post_data['month_year'], $claim_data['basic_pay'], $claim_data['pay_scale'], $claim_data['grade_pay'], $claim_data['pf_number'], $claim_data_json, $claim_data['total_amount'], $claim_data['amount_in_words']);
$stmt->execute();

// --- Split processed journeys for two pages (15 ROWS PER PAGE) ---
$journeys_page1 = array_slice($journeys, 0, 15);
$journeys_page2 = array_slice($journeys, 15, 15);

$total_page1 = 0;
foreach ($journeys_page1 as $row) {
    $total_page1 += (float)($row['rate'] ?? 0);
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>TA Claim for <?php echo htmlspecialchars($claim_data['month_year_english']); ?></title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans&family=Noto+Sans+Devanagari&display=swap');
        body { font-family: 'Noto Sans', sans-serif; margin: 0; padding: 0; background-color: #525659; font-size: 10pt; }
        .page { width: 297mm; min-height: 210mm; padding: 10mm; margin: 10mm auto; border: 1px #D3D3D3 solid; background: white; box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); box-sizing: border-box; display: flex; flex-direction: column; }
        .hindi { font-family: 'Noto Sans Devanagari', sans-serif; }
        
        .page-header { display: flex; justify-content: space-between; align-items: flex-start; }
        .header-title { text-align: center; line-height: 1.2; flex-grow: 1; }
        .header-title h1 { margin: 0; font-size: 14pt; }
        .header-title h2 { margin: 0; font-size: 16pt; }
        .header-title p { text-align: right; margin: 0; font-size: 9pt; }
        .top-right-codes { font-size: 9pt; text-align: right; line-height: 1.4; flex-shrink: 0; }
        
        .details-grid { display: flex; justify-content: space-between; margin-top: 3mm;}
        .details-grid p, .details-section p { margin: 0; line-height: 1.3; font-size: 9pt;}
        .details-section { margin-top: 2mm; }

        table { width: 100%; border-collapse: collapse; margin-top: 3mm; table-layout: fixed; }
        th, td { border: 1px solid black; padding: 0.5mm; font-size: 8pt; text-align: center; vertical-align: top; word-wrap: break-word; }
        th { font-weight: bold; }
        th .col-num { font-size: 7pt; display: block; margin-top: 1px; }
        .vertical-text { writing-mode: vertical-rl; transform: rotate(180deg); font-size: 8pt; white-space: nowrap; text-align: center; margin: auto;}
        
        .page-footer { margin-top: auto; padding-top: 5mm; }
        .footer-section { font-size: 9pt; line-height: 1.4; text-align: justify; }
        .signature-section { display: grid; grid-template-columns: repeat(4, 1fr); margin-top: 10mm; font-size: 9pt; text-align: center; }
        .note-section { font-size: 8pt; margin-top: 5mm; border-top: 1px solid black; padding-top: 2mm; text-align: justify;}
        .no-print { position: fixed; top: 10px; right: 10px; z-index: 100; }
        .no-print button { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; box-shadow: 0 2px 4px rgba(0,0,0,0.2); }

        @page { size: A4 landscape; margin: 10mm; }
        @media print {
            html, body { width: 297mm; height: 210mm; }
            body { margin: 0; }
            .page { margin: 0; border: initial; border-radius: initial; width: initial; min-height: initial; box-shadow: initial; background: initial; page-break-after: always; }
            .no-print { display: none; }
        }
    </style>
</head>
<body>
    <div class="no-print"><button onclick="window.print()">Print or Save as PDF</button></div>
    
    <!-- Page 1 -->
    <div class="page">
        <div> <!-- Header and Details Wrapper -->
            <div class="page-header">
                <div class="header-title">
                    <h1 class="hindi">उत्तर मध्य रेलवे / North Central Railway</h1>
                    <h2 class="hindi">यात्रा भत्ता जर्नल / TRAVELLING ALLOWANCE JOURNAL</h2>
                    <p>नियम जिससे शासित है/ Rule by which governed-- RPS</p>
                </div>
                <div class="top-right-codes hindi">
                    जीए.31एस आर सी/जी 1677<br>
                    <u>जी 69 एफ/जी 69 एफ/ए</u><br>
                    GA 31 SRC/G 1677<br>
                    G 69 F/G 69 F/A
                </div>
            </div>
            <div class="details-grid">
                <p><strong class="hindi">शाखा/Branch:</strong> सिगनल एवं दूरसंचार</p>
                <p><strong class="hindi">मंडल/जिला / Division/Distt:</strong> झाँसी मंडल / Jhansi Division</p>
            </div>
            <div class="details-section">
                <p><strong class="hindi">मुख्यालय / Headquarters at:</strong> <?php echo htmlspecialchars($claim_data['hq']); ?></p>
                <p><span class="hindi"><?php echo htmlspecialchars($claim_data['name_hindi']); ?> द्वारा किये गये कार्यों का जर्नल, जिनके बारे मे <?php echo htmlspecialchars($claim_data['month_year_hindi']); ?> के लिये भत्ता मांगा गया है।</span></p>
                <p>Journal of duties performed by <?php echo htmlspecialchars($claim_data['name_english']); ?> for which allowance for <?php echo htmlspecialchars($claim_data['month_year_english']); ?> is claimed.</p>
                <p><strong class="hindi">पदनाम/Designation:</strong> <?php echo htmlspecialchars($claim_data['post_name_with_stn']); ?></p>
                <p>
                    <strong class="hindi">वेतन/Pay.</strong> Rs. <?php echo htmlspecialchars($claim_data['basic_pay']); ?> (<?php echo htmlspecialchars($claim_data['pay_scale']); ?>)
                    &nbsp;&nbsp;<strong>G.P.</strong> <?php echo htmlspecialchars($claim_data['grade_pay']); ?>
                    &nbsp;&nbsp;<strong class="hindi">PF NO.</strong> <?php echo htmlspecialchars($claim_data['pf_number']); ?>
                </p>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th style="width: 7%;"><span class="hindi">माह, दिनांक</span><br>Month, Date<span class="col-num">1</span></th>
                    <th style="width: 5.5%;"><span class="hindi">गाडी संख्या</span><br>Train No.<span class="col-num">2</span></th>
                    <th style="width: 5.5%;"><span class="hindi">प्रस्थान समय</span><br>Time Departure<span class="col-num">3</span></th>
                    <th style="width: 5.5%;"><span class="hindi">आगमन समय</span><br>Time arrived<span class="col-num">4</span></th>
                    <th style="width: 5.5%;"><span class="hindi">से</span><br>From<span class="col-num">5</span></th>
                    <th style="width: 5.5%;"><span class="hindi">तक</span><br>To<span class="col-num">6</span></th>
                    <th style="width: 4%;"><span class="hindi">कि.मी.</span><br>Kms.<span class="col-num">7</span></th>
                    <th style="width: 5%;"><span class="hindi">दिन/रात</span><br>DA %<span class="col-num">8</span></th>
                    <th style="width: 16.5%;"><span class="hindi">यात्रा का उद्देश्य</span><br>Object of journey<span class="col-num">9</span></th>
                    <th style="width: 5%;"><span class="hindi">दर</span><br>Rate<span class="col-num">10</span></th>
                    <th style="width: 15%;"><span class="hindi">घरेलू उपयोग</span><br>Distance for which private/public conveyance is used.<span class="col-num">11</span></th>
                    <th style="width: 15%;"><span class="hindi">दूरी अनुसूची</span><br>Reference to Item 20 in schedule of distance.<span class="col-num">12</span></th>
                </tr>
            </thead>
            <tbody>
                <?php for ($i = 0; $i < 15; $i++): $row = $journeys_page1[$i] ?? null; ?>
                <tr>
                    <td><?php echo isset($row['date']) ? htmlspecialchars(date('d-m-Y', strtotime($row['date']))) : '&nbsp;'; ?></td>
                    <td><?php echo htmlspecialchars($row['train_no'] ?? ''); ?></td>
                    <td><?php echo htmlspecialchars($row['dep_time'] ?? ''); ?></td>
                    <td><?php echo htmlspecialchars($row['arr_time'] ?? ''); ?></td>
                    <td><?php echo htmlspecialchars($row['from_stn'] ?? ''); ?></td>
                    <td><?php echo htmlspecialchars($row['to_stn'] ?? ''); ?></td>
                    <?php if ($i === 0): ?>
                        <td rowspan="16" style="vertical-align: middle;"><div class="vertical-text">Above to 8KM</div></td>
                    <?php endif; ?>
                    
                    <?php
                    // --- FINAL Correct rendering logic for merged cells ---
                    if (empty($row['is_merged_row'])) {
                        // This is a standalone row or the TOP row of a merge block.
                        $rowspan = $row['merge_span'] ?? 1;
                        $rowspan_attr = ($rowspan > 1) ? "rowspan='{$rowspan}' style='vertical-align: middle;'" : "";
                        ?>
                        <td <?php echo $rowspan_attr; ?>><?php echo htmlspecialchars($row['percentage'] ?? ''); ?></td>
                        <td <?php echo $rowspan_attr; ?>><?php echo htmlspecialchars($row['purpose'] ?? ''); ?></td>
                        <td <?php echo $rowspan_attr; ?> style="text-align: right; <?php if($rowspan > 1) echo 'vertical-align: middle;'; ?>">
                            <?php echo isset($row['rate']) ? number_format((float)$row['rate'], 2) : ''; ?>
                        </td>
                        <td <?php echo $rowspan_attr; ?>><?php echo isset($row['pass_no']) ? 'On duty SPL Pass no. ' . htmlspecialchars($row['pass_no']) : ''; ?></td>
                        <?php
                    }
                    // For merged rows ('is_merged_row' is true), we print NOTHING for the 4 merged columns.
                    // The browser will correctly handle the layout because of the rowspan from the row above.
                    ?>
                    <td>&nbsp;</td>
                </tr>
                <?php endfor; ?>
                <!-- **** CORRECTED TOTAL ROW **** -->
                <tr>
                    <td colspan="6" style="text-align: right; font-weight: bold;">Total / <span class="hindi">कुल</span></td>
                    <!-- Col 7 is covered by rowspan -->
                    <td colspan="3" style="text-align: right; font-weight: bold;"><?php echo number_format($total_page1, 2); ?></td> <!-- This covers cols 8, 9, 10 -->
                    <td colspan="2"></td> <!-- This covers cols 11, 12 -->
                </tr>
            </tbody>
        </table>
        <div class="page-footer">
            <!-- Footer is on the last page -->
        </div>
    </div>

    <!-- Page 2 -->
    <div class="page">
        <table>
            <!-- Table headers for page 2 -->
             <thead>
                <tr>
                    <th style="width: 7%;"><span class="col-num">1</span></th>
                    <th style="width: 5.5%;"><span class="col-num">2</span></th>
                    <th style="width: 5.5%;"><span class="col-num">3</span></th>
                    <th style="width: 5.5%;"><span class="col-num">4</span></th>
                    <th style="width: 5.5%;"><span class="col-num">5</span></th>
                    <th style="width: 5.5%;"><span class="col-num">6</span></th>
                    <th style="width: 4%;"><span class="col-num">7</span></th>
                    <th style="width: 5%;"><span class="col-num">8</span></th>
                    <th style="width: 16.5%;"><span class="col-num">9</span></th>
                    <th style="width: 5%;"><span class="col-num">10</span></th>
                    <th style="width: 15%;"><span class="col-num">11</span></th>
                    <th style="width: 15%;"><span class="col-num">12</span></th>
                </tr>
            </thead>
            <tbody>
                 <tr>
                    <td colspan="9" style="text-align: right; font-weight: bold;">B/F</td>
                    <td style="text-align: right; font-weight: bold;"><?php echo number_format($total_page1, 2); ?></td>
                    <td colspan="2"></td>
                </tr>
                <?php for ($i = 0; $i < 15; $i++): $row = $journeys_page2[$i] ?? null; ?>
                <tr>
                    <td><?php echo isset($row['date']) ? htmlspecialchars(date('d-m-Y', strtotime($row['date']))) : '&nbsp;'; ?></td>
                    <td><?php echo htmlspecialchars($row['train_no'] ?? ''); ?></td>
                    <td><?php echo htmlspecialchars($row['dep_time'] ?? ''); ?></td>
                    <td><?php echo htmlspecialchars($row['arr_time'] ?? ''); ?></td>
                    <td><?php echo htmlspecialchars($row['from_stn'] ?? ''); ?></td>
                    <td><?php echo htmlspecialchars($row['to_stn'] ?? ''); ?></td>
                     <?php if ($i === 0): ?>
                        <td rowspan="17" style="vertical-align: middle;"><div class="vertical-text">Above to 8KM</div></td>
                    <?php endif; ?>
                    
                    <?php
                     // --- FINAL Correct rendering logic for merged cells (for Page 2) ---
                     if (empty($row['is_merged_row'])) {
                        $rowspan = $row['merge_span'] ?? 1;
                        $rowspan_attr = ($rowspan > 1) ? "rowspan='{$rowspan}' style='vertical-align: middle;'" : "";
                        ?>
                        <td <?php echo $rowspan_attr; ?>><?php echo htmlspecialchars($row['percentage'] ?? ''); ?></td>
                        <td <?php echo $rowspan_attr; ?>><?php echo htmlspecialchars($row['purpose'] ?? ''); ?></td>
                        <td <?php echo $rowspan_attr; ?> style="text-align: right; <?php if($rowspan > 1) echo 'vertical-align: middle;'; ?>">
                            <?php echo isset($row['rate']) ? number_format((float)$row['rate'], 2) : ''; ?>
                        </td>
                        <td <?php echo $rowspan_attr; ?>><?php echo isset($row['pass_no']) ? 'On duty SPL Pass no. ' . htmlspecialchars($row['pass_no']) : ''; ?></td>
                        <?php
                    }
                    ?>
                    <td>&nbsp;</td>
                </tr>
                <?php endfor; ?>
                <!-- **** CORRECTED GRAND TOTAL ROW **** -->
                <tr>
                    <td colspan="8" style="text-align: right; font-weight: bold;">G. Total</td>
                    <!-- Col 7 is covered by rowspan -->
                    <td colspan="1" style="text-align: right; font-weight: bold;"><?php echo number_format($claim_data['total_amount'], 2); ?></td> <!-- This covers col 10 -->
                    <td colspan="2"></td> <!-- This covers cols 11, 12 -->
                </tr>
                <tr>
                    <td colspan="11" style="text-align: left; font-weight: bold;">(Total Rs. <?php echo htmlspecialchars($claim_data['amount_in_words']); ?>)</td>
                </tr>
            </tbody>
        </table>
        <div class="page-footer">
            <div class="footer-section">
                <p><span class="hindi">मैं प्रमाणित करता हूं कि उपर्युक्त <?php echo htmlspecialchars($claim_data['name_hindi']); ?> उस अवधि के दौरान, जिसके लिये इस बिल में भत्ता मांगा गया है रेलवे के कार्य से ड्यूटी पर मुख्यालय स्टेशन से बाहर गया था। इस अधिकारी ने रेलमार्ग / समुद्रमार्ग / सक. वाहन/वायुमार्ग से यात्रा की और इसे मुफ्त पास या सरकारी स्थानीय निधि य भारत सरकार के खर्च पर यात्रा करने की सुविधा दी गयी नही दी गयी थी।</span></p>
                <p>I hereby certify that the above mentioned <?php echo htmlspecialchars($claim_data['name_english']); ?> was absent on duty from his headquarters' station during the period for in this bill charged on railway business and that the officer performed the journey by Rail/Sea/Road/Air and was allowed/not allowed free pass or locomotion at the expense of Government local fund or Indian state.</p>
                <br>
                <p><span class="hindi">मैं प्रमाणित करता हूं कि ड्यूटी पास पर की गयी यात्रा तथा विराम के बारे में जिसके लिये इस बिल में यात्रा भत्ता / दैनिक भत्ता मांगा गया है. कि किसी भी स्त्रोत से कोई यात्रा भत्ता / दैनिक भत्ता या अन्य पारिश्रमिक नहीं लिया गयी है।</span></p>
                <p>I certify that no TA/DA or any other remuneration has been drawn from any other source in respect of the journeys performed on duty pass and also for the halts for which TA/DA has been claimed in this bill.</p>
            </div>
            <div class="signature-section">
                <p><strong class="hindi">प्रतिहस्ताक्षरित</strong><br>Countersigned</p>
                <p><strong class="hindi">नियंत्रण अधिकारी</strong><br>Controlling Officer</p>
                <p><strong class="hindi">कार्यालय प्रमुख</strong><br>Head of Office</p>
                <p><strong class="hindi">भत्ता मांगने वाले अधिकारी का हस्ताक्षर</strong><br>Signature of Officer/Claiming T.A.</p>
            </div>
            <div class="note-section">
                <p><strong class="hindi">टिप्पणी - </strong><span class="hindi">किसी एक रेलवे से दूसरी रेलवे पर स्थानान्तरण होने पर यात्रा भत्ता बिल पर यह प्रमाणित किया जाना चाहिये कि मुप्त पास या सरकारी खर्च पर यात्रा करने की सुविधा हो गयी थी या नहीं।</span></p>
                <p><strong>Note :- </strong>On T.A. Bills of transfer from one Railway to another a certificate whether or not a free pass or Locomotion at Government expense was allowed should be recorded.</p>
            </div>
        </div>
    </div>
</body>
</html>
