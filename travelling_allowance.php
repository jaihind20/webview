<?php
require_once 'db_connect.php';

// Page Protection
if (!isset($_SESSION['user_id']) || $_SESSION['role_name'] === 'Admin') {
    header("Location: login.php");
    exit();
}
$user_id = $_SESSION['user_id'];

// Fetch user's basic info to pre-fill the form
$user_stmt = $conn->prepare("
    SELECT u.full_name, u.username, r.role_name, s.station_name
    FROM users u
    LEFT JOIN roles r ON u.role_id = r.id
    LEFT JOIN stations s ON u.station_id = s.id
    WHERE u.id = ?
");
$user_stmt->bind_param("i", $user_id);
$user_stmt->execute();
$user_info = $user_stmt->get_result()->fetch_assoc();

require_once 'header.php';
?>
<script src="https://cdn.jsdelivr.net/gh/alpinejs/alpine@v2.x.x/dist/alpine.min.js" defer></script>

<div class="flex h-full bg-gray-800">
    <?php require_once 'sidebar.php'; ?>
    <div class="flex-1 flex flex-col overflow-hidden">
        <header class="flex justify-between items-center p-6 border-b border-gray-700">
            <div class="flex items-center">
                 <button @click="sidebarOpen = !sidebarOpen" class="text-gray-400 focus:outline-none lg:hidden mr-4"><svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4 6H20M4 12H20M4 18H20" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path></svg></button>
                <h1 class="text-2xl font-semibold text-gray-100">Travelling Allowance (TA) Claim</h1>
            </div>
        </header>

        <main class="flex-1 overflow-y-auto p-6" x-data="taForm()">
            <form action="generate_ta_pdf.php" method="POST" target="_blank">
                <!-- Employee Details Section -->
                <div class="bg-gray-900 p-6 rounded-lg shadow-lg">
                    <h3 class="text-xl font-semibold mb-6 border-b border-gray-700 pb-4">Employee Details</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                        <input type="hidden" name="name_english" value="<?php echo htmlspecialchars($user_info['full_name']); ?>">
                        <div><label class="text-sm text-gray-400">Name:</label><p class="font-bold"><?php echo htmlspecialchars($user_info['full_name']); ?></p></div>
                        <div><label class="text-sm text-gray-400">Designation:</label><p class="font-bold"><?php echo htmlspecialchars($user_info['role_name']); ?> (<?php echo htmlspecialchars($user_info['station_name']); ?>)</p></div>
                        <input type="hidden" name="post_name_with_stn" value="<?php echo htmlspecialchars($user_info['role_name'] . ' (' . $user_info['station_name'] . ')'); ?>">
                        <div>
                            <label for="hq" class="text-sm text-gray-400">Headquarters:</label>
                            <input type="text" id="hq" name="hq" required class="mt-1 w-full bg-gray-700 p-2 rounded" value="<?php echo htmlspecialchars($user_info['station_name']); ?>">
                        </div>
                         <div>
                            <label for="month_year" class="text-sm text-gray-400">Month & Year of Claim:</label>
                            <input type="month" id="month_year" name="month_year" required class="mt-1 w-full bg-gray-700 p-2 rounded" value="<?php echo date('Y-m'); ?>">
                        </div>
                        <div>
                            <label for="basic_pay" class="text-sm text-gray-400">Basic Pay:</label>
                            <input type="number" id="basic_pay" name="basic_pay" required class="mt-1 w-full bg-gray-700 p-2 rounded" placeholder="e.g., 50500">
                        </div>
                         <div>
                            <label for="pay_scale" class="text-sm text-gray-400">Pay Scale:</label>
                            <input type="text" id="pay_scale" name="pay_scale" required class="mt-1 w-full bg-gray-700 p-2 rounded" placeholder="e.g., 5200-20200">
                        </div>
                        <div>
                            <label for="grade_pay" class="text-sm text-gray-400">Grade Pay:</label>
                            <input type="number" id="grade_pay" name="grade_pay" required class="mt-1 w-full bg-gray-700 p-2 rounded" placeholder="e.g., 2800">
                        </div>
                         <div>
                            <label for="pf_number" class="text-sm text-gray-400">PF Number:</label>
                            <input type="text" id="pf_number" name="pf_number" required class="mt-1 w-full bg-gray-700 p-2 rounded" placeholder="e.g., 12345678901">
                        </div>
                        <!-- NEW: Base TA Rate Field -->
                        <div class="md:col-span-1">
                            <label for="base_ta_rate" class="text-sm text-gray-400">Base TA Rate (100%):</label>
                             <input type="number" id="base_ta_rate" x-model.number="baseDARate" @input="recalculateAll()" class="mt-1 w-full bg-blue-900 p-2 rounded" placeholder="e.g., 500">
                        </div>
                    </div>
                </div>

                <!-- Journey Details Section -->
                <div class="bg-gray-900 p-6 rounded-lg shadow-lg mt-6">
                     <h3 class="text-xl font-semibold mb-4">Journey Details (for Auto-Calculation, check "Merge" on return journey)</h3>
                    <div class="overflow-x-auto">
                        <table class="min-w-full">
                            <thead>
                                <tr>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">Date</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">Train No.</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">Dep. Time</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">Arr. Time</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">From</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">To</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">KMs</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">DA %</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">Purpose</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">Amount</th>
                                    <th class="px-2 py-2 text-left text-xs text-gray-400">Duty Pass</th>
                                    <th class="px-2 py-2 text-center text-xs text-gray-400">Merge</th>
                                    <th class="w-10"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <template x-for="(row, index) in rows" :key="index">
                                    <tr class="border-b border-gray-700">
                                        <!-- UPDATED: Added x-model and @change for auto-calculation -->
                                        <td><input type="date" :name="`journeys[${index}][date]`" x-model="row.date" @change="calculateDA(index)" class="w-full bg-gray-700 p-1 rounded my-1"></td>
                                        <td><input type="text" :name="`journeys[${index}][train_no]`" class="w-20 bg-gray-700 p-1 rounded my-1"></td>
                                        <td><input type="time" :name="`journeys[${index}][dep_time]`" x-model="row.dep_time" @change="calculateDA(index)" class="w-full bg-gray-700 p-1 rounded my-1"></td>
                                        <td><input type="time" :name="`journeys[${index}][arr_time]`" x-model="row.arr_time" @change="calculateDA(index)" class="w-full bg-gray-700 p-1 rounded my-1"></td>
                                        <td><input type="text" :name="`journeys[${index}][from_stn]`" class="w-20 bg-gray-700 p-1 rounded my-1"></td>
                                        <td><input type="text" :name="`journeys[${index}][to_stn]`" class="w-20 bg-gray-700 p-1 rounded my-1"></td>
                                        <td><input type="number" :name="`journeys[${index}][kms]`" class="w-20 bg-gray-700 p-1 rounded my-1"></td>
                                        <td><input type="number" :name="`journeys[${index}][percentage]`" x-model.number="row.percentage" class="w-20 bg-gray-700 p-1 rounded my-1" placeholder="e.g., 30" readonly></td>
                                        <td><input type="text" :name="`journeys[${index}][purpose]`" x-model="row.purpose" @input="updatePurpose(index)" class="w-full bg-gray-700 p-1 rounded my-1"></td>
                                        <td><input type="number" :name="`journeys[${index}][rate]`" x-model.number="row.rate" @input="calculateTotal()" class="w-24 bg-gray-700 p-1 rounded my-1" placeholder="e.g., 500"></td>
                                        <td><input type="text" :name="`journeys[${index}][pass_no]`" class="w-full bg-gray-700 p-1 rounded my-1"></td>
                                        <td class="text-center">
                                            <template x-if="index > 0">
                                                <input type="checkbox" :name="`journeys[${index}][merge]`" value="on" x-model="row.is_return_journey" @change="calculateDA(index)" title="Check this for the return journey to auto-calculate TA for the round trip" class="bg-gray-700 border-gray-600 h-4 w-4">
                                            </template>
                                        </td>
                                        <td><button type="button" @click="removeRow(index)" class="text-red-500 hover:text-red-400">&times;</button></td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>
                    </div>
                    <button type="button" @click="addRow()" class="mt-4 bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">+ Add Journey</button>
                </div>
                
                <div class="mt-6 flex justify-end items-center gap-6">
                    <div class="text-right">
                        <p class="text-gray-400">Total Amount:</p>
                        <p class="text-2xl font-bold" x-text="`Rs. ${totalAmount.toFixed(2)}`"></p>
                        <input type="hidden" name="total_amount" :value="totalAmount">
                    </div>
                    <button type="submit" class="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg text-lg">Generate & Download PDF</button>
                </div>
            </form>
        </main>
    </div>
</div>

<!-- NEW: Updated Javascript with Auto-Calculation Logic -->
<script>
    function taForm() {
        return {
            baseDARate: 500.00,
            rows: [],
            totalAmount: 0,
            
            init() {
                // Initialize with one empty row
                this.addRow();
            },

            addRow() {
                this.rows.push({ 
                    date: '', 
                    dep_time: '', 
                    arr_time: '',
                    purpose: '',
                    is_return_journey: false, 
                    percentage: 0, 
                    rate: 0 
                });
            },

            removeRow(index) {
                // Before removing, check if it was a return journey and reset the outward journey if needed
                if(index > 0 && this.rows[index].is_return_journey) {
                    this.rows[index-1].percentage = 0;
                    this.rows[index-1].rate = 0;
                }
                this.rows.splice(index, 1);
                this.recalculateAll();
            },
            
            recalculateAll() {
                for (let i = 0; i < this.rows.length; i++) {
                    if (this.rows[i].is_return_journey) {
                        this.calculateDA(i);
                    }
                }
                this.calculateTotal();
            },
            
            updatePurpose(index) {
                // If this is an outward journey and its corresponding return journey is merged, update the return purpose as well
                if(index % 2 === 0 && this.rows[index+1] && this.rows[index+1].is_return_journey){
                    this.rows[index+1].purpose = this.rows[index].purpose;
                }
            },

            calculateDA(index) {
                const isMerging = this.rows[index].is_return_journey;
                const outwardRow = this.rows[index - 1];
                const returnRow = this.rows[index];

                if (!isMerging) {
                    // If un-merging, reset the pair
                    outwardRow.percentage = 0;
                    outwardRow.rate = 0;
                    this.calculateTotal();
                    return;
                }

                // If merging, copy the purpose from the outward journey
                returnRow.purpose = outwardRow.purpose;

                if (outwardRow.date && outwardRow.dep_time && returnRow.date && returnRow.arr_time) {
                    try {
                        const departureDateTime = new Date(`${outwardRow.date}T${outwardRow.dep_time}`);
                        const arrivalDateTime = new Date(`${returnRow.date}T${returnRow.arr_time}`);

                        const durationMs = arrivalDateTime - departureDateTime;
                        const durationHours = durationMs / (1000 * 60 * 60);

                        if (durationHours > 0) {
                            if (durationHours > 12) { // Changed to > 12 for 100%
                                outwardRow.percentage = 100;
                            } else if (durationHours >= 6) {
                                outwardRow.percentage = 70;
                            } else {
                                outwardRow.percentage = 30;
                            }
                            outwardRow.rate = parseFloat((this.baseDARate * (outwardRow.percentage / 100)).toFixed(2));
                            
                            // Return journey values are 0 for amount, but percentage can be shown for clarity
                            returnRow.percentage = 0;
                            returnRow.rate = 0;
                        } else {
                            outwardRow.percentage = 0;
                            outwardRow.rate = 0;
                        }

                    } catch (e) {
                        console.error("Invalid date/time for calculation:", e);
                    }
                }
                
                this.calculateTotal();
            },

            calculateTotal() {
                this.totalAmount = this.rows.reduce((acc, row) => {
                    const rate = parseFloat(row.rate) || 0;
                    return acc + rate;
                }, 0);
            }
        }
    }
</script>
<?php require_once 'footer.php'; ?>
