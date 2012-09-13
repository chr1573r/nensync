<html>
<head>
<link href='http://fonts.googleapis.com/css?family=Nova+Square' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Metrophobic' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=VT323' rel='stylesheet' type='text/css'>
<link href='http://fonts.googleapis.com/css?family=Orbitron:500' rel='stylesheet' type='text/css'>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"> 

<script type="text/javascript" src="/js/ajax.js"> </script>
<script type="text/javascript" src="./ajax-logtail.js"> </script>

<link href="nencon.css" rel="stylesheet" type="text/css" />

<body>
    <h1>
	nensync - info console
	</h1>
<hr>
	<h2>
	node:
	<?php system("hostname"); ?>
	</h2>

<hr>
</br>
<div id="textbox">
  <p class="alignleft"><b>Uptime:</b><?php system("uptime"); ?> </p>
  <p class="alignright"><b>Stored data: </b><?php system("du -hs /home/nen/data"); ?> </p>
  
</div>

<div style="clear: both;"></div>

<div id="textbox2">
  	<p class="alignleft">
		</br>
		<b>Server/Client cfg:</b> </br><?php exec("cat /home/nen/server.cfg /home/nen/client.cfg", $output1);
			foreach($output1 as $out){
					echo $out;
					echo "<br />";
				} ?>
	</p>
	
	
  <p class="alignright">
					</br>
	                <b>Node list:</b> </br><?php exec("cat /home/nen/node.lst", $output2);
                        foreach($output2 as $out){
                                        echo $out;
                                        echo "<br />";
                                } ?>
								
<!--
<div id="textbox3">
	<p class="alignright">
                        <b>File info:</b> </br><?php exec("cat /home/nen/node.lst", $output2);
                        foreach($output2 as $out){
                                        echo $out;
                                        echo "<br />";
                                } ?>

-->
</div>

<div style="clear: both;"></div>

<div class=log id="log";>
<center>nensync log viewer (sync.log)</center><hr> To begin viewing the log live in this window, click Start Viewer. To stop the window refreshes, click Pause Viewer.
</div>

<div style="width:520px ; margin-left: auto ; margin-right: auto ;">
</br>
<button onclick="getLog('start');">Start Viewer</button>
<button onclick="stopTail();">Stop Viewer</button>
</div>

</body>

<!--- Comment <meta http-equiv="refresh" content="5" >
 
