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
// base dir on local server
$base_dir = "/var/www/html/builds";
// needed sub directory structure
$builds_sub_dirs = "device/".$device."/WEEKLY/";
// complete path
$builds_complete_dirs = $base_dir."/".$builds_sub_dirs;

###########################
function getFileBuildDate($CurrentZipFile)
{
$zip = zip_open($CurrentZipFile);
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
                               $getRoBuildDate = explode("=", $Matches[0]);
                               echo " ".$getRoBuildDate[1];
                            }
                     }
                  zip_entry_close($zip_entry);
               }
         }
      }
zip_close($zip);
   }
}
###########################

// dir exist?
if ( is_dir ( $builds_complete_dirs ))
{
    // open dir
    if ( $handle = opendir($builds_complete_dirs) )
    {
        // read dir
        while (($eachFile = readdir($handle)) !== false)
        {
            if (preg_match("/aicp_".$device."/i", $eachFile))
            {
                $SplitFileName1 = explode("WEEKLY-", $eachFile);
                $SplitFileName2 = explode(".", $SplitFileName1[1]);
                echo $SplitFileName2[0];
                getFileBuildDate($builds_complete_dirs."/".$eachFile);
            }
        }
    closedir($handle);
    }
}
else
{
   echo "directory: ".$builds_complete_dirs." doesn't exist!!!</br>";
}
?>
