<?php

mysql_connect("localhost","root","nic@123") or die("error");
mysql_select_db('hit_count_db') or die("could not connect to database");

$page =$_POST['page'];

if(mysql_num_rows(mysql_query("SELECT fld_count FROM tbl_hit_counter WHERE fld_page = '$page'")))
	{
	//A counter for this page  already exsists. Now we have to update it.

		$updatecounter = mysql_query("UPDATE tbl_hit_counter SET fld_count = fld_count+1 WHERE fld_page = '$page'");
		if (!$updatecounter) 
		{
		die ("Can't update the counter : " . mysql_error()); // remove ?
		}
	
	} else{
            $addcounter = mysql_query("INSERT INTO tbl_hit_counter (fld_page, fld_count) VALUES('$page',fld_count+1) ") ;
            if (!$addcounter) 
            {
                die('Could not add IP : ' . mysql_error()); // remove ?
            }
        }
        
// gather user data
$ip= $_SERVER["REMOTE_ADDR"]; 

if(!mysql_num_rows(mysql_query("SELECT fld_ip_address FROM tbl_ip_info WHERE fld_ip_address = '$ip' AND fld_page = '$page'"))) // check if the IP is in database
{
	// if not , add it.	
	$adddata = mysql_query("INSERT INTO tbl_ip_info (fld_count,fld_ip_address,fld_page) VALUES(fld_count+1,'$ip','$page') ") ;
	if (!$adddata) 
	{
	    die('Could not add IP : ' . mysql_error()); // remove ?
	}
}
else
    {
        $updatedata = mysql_query("UPDATE tbl_ip_info SET fld_count = fld_count+1 WHERE fld_ip_address = '$ip' AND fld_page = '$page'") ;
	if (!$updatedata) 
	{
	    die('Could not add IP : ' . mysql_error()); // remove ?
	}
}
