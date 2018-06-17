<?php
/*
 * Copyright (C) 2018 AICP
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// base dir on local server
$base_dir = "/var/www/html_81/builds";
// base url for OTAs
$base_url = 'http://heimdal:81/builds';

$device = $_GET['device'];
$data =array();
$data ['device'] = $device;
$data1 = array();

###########################
function filesizemb($file)
{
    return number_format(filesize($file) / pow(1024, 2), 0,'.','');
}
###########################

// dir exist?
if ( is_dir ( $base_dir ))
{
    // open dir
    if ( $handle = opendir($base_dir) )
    {
        // read dir
        while (($file = readdir($handle)) !== false)
        {
            if (preg_match("/aicp_".$device."/i", $file)) {
            $get_md5 = md5($file);
            $get_filesize = filesizemb($base_dir."/".$file);
            array_push($data1, array('name' => $file,'version' => "13.1-WEEKLY\no-13.1",'size' => $get_filesize,'url' => $base_url.'/'.$file,'md5' => $get_md5));
        }
    }
    $data ['updates'] = $data1;
    closedir($handle);
    }
}
$json = json_encode($data, JSON_UNESCAPED_SLASHES);
// return json object
echo $json;
?>