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
// get device
$device = $_GET['device'];
// get type
$type = $_GET['type'];
// check call params
if (empty($device)|| empty($type))
{
    echo "<h3>missing params device and type</h3>";
}
// base dir on local server
$base_dir = "/var/www/html/builds";
// needed sub directory structure
$builds_sub_dirs = "device/".$device."/".$type."/";
// complete path
$builds_complete_dirs = $base_dir."/".$builds_sub_dirs;

###########################
# extract from given ROM-file ro.build.date.utc from file system/build.prop
function getFileBuildUtc($CurrentZipFile)
{
$zip = zip_open($CurrentZipFile);
$FileBuildUtc;
if ($zip)
   {
   while ($zip_entry = zip_read($zip))
      {
          if (zip_entry_name($zip_entry) == "system/build.prop")
          {
             if (zip_entry_open($zip, $zip_entry))
               {
                  $contents = zip_entry_read($zip_entry);
                  $getEachrow = explode(" ", $contents);
                  for ($x = 0; $x < count($getEachrow); $x++)
                     {
                         preg_match("/ro.build.date.utc=([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])/",$getEachrow[$x-1],$Matches);
                         if ($Matches[0])
                            {
                               $getRoBuildUtc = explode("=", $Matches[0]);
                               $FileBuildUtc = $getRoBuildUtc[1];
                            }
                     }
                  zip_entry_close($zip_entry);
               }
         }
      }
zip_close($zip);
}
return $FileBuildUtc;
}
###########################

// dir exist?
if ( is_dir ( $builds_complete_dirs ))
{
    $UpdateDate;
    $UpdateUts;
    // open dir
    if ( $handle = opendir($builds_complete_dirs) )
    {
        // read dir
        while (($eachFile = readdir($handle)) !== false)
        {
            if (preg_match("/aicp_".$device."/i", $eachFile))
            {
                $SplitFileName1 = explode($type."-", $eachFile);
                $SplitFileName2 = explode(".", $SplitFileName1[1]);
                $UpdateDate = $SplitFileName2[0];
                $UpdateUtc = getFileBuildUtc($builds_complete_dirs."/".$eachFile);
            }
        }
    closedir($handle);
    }
    // Output for frontend
    echo $UpdateDate." ".$UpdateUtc;
}
else
{
   echo "directory: ".$builds_complete_dirs." doesn't exist!!!</br>";
}
?>
