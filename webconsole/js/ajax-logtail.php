<?php
// logtail.php
$cmd = "tail -10 /home/nen/sync.log";
exec("$cmd 2>&1", $output);
foreach($output as $outputline) {
 echo ("$outputline\n");
}
?>
