<?php
/*
 * FCKeditor - The text editor for internet
 * Copyright (C) 2003 Frederico Caldeira Knabben
 *
 * Licensed under the terms of the GNU Lesser General Public License
 * (http://www.opensource.org/licenses/lgpl-license.php)
 *
 * For further information go to http://www.fredck.com/FCKeditor/ 
 * or contact fckeditor@fredck.com.
 *
 * upload.php: Basic file upload manager for the editor. You have
 *   to have set a directory called "userimages" in the root folder
 *   of your web site.
 *
 * Authors:
 *   Frederic TYNDIUK (http://www.ftls.org/ - tyndiuk[at]ftls.org)
 */

// Init var :

	$UPLOAD_BASE_URL = '/userimages/';
	$UPLOAD_BASE_DIR = getenv("DOCUMENT_ROOT").$UPLOAD_BASE_URL;

// End int var

?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE>File Uploader</TITLE>
		<LINK rel="stylesheet" type="text/css" href="../../css/fck_dialog.css">
	</HEAD>
	<BODY><form>
		<TABLE eight="100%" width="100%">
			<TR>
				<TD align=center valign=middle><B>
					Upload in progress...
<font color='red'><BR><BR>
<?php 

if (file_exists($UPLOAD_BASE_DIR.$HTTP_POST_FILES['FCKeditor_File']['name'])) {
	echo "Error : File ".$HTTP_POST_FILES['FCKeditor_File']['name']." exists, can't overwrite it...";
	echo '<BR><BR><INPUT type="button" value=" Cancel " onclick="window.close()">';
} else {
	if (is_uploaded_file($HTTP_POST_FILES['FCKeditor_File']['tmp_name'])) {
		$savefile = $UPLOAD_BASE_DIR.$HTTP_POST_FILES['FCKeditor_File']['name'];

		if (move_uploaded_file($HTTP_POST_FILES['FCKeditor_File']['tmp_name'], $savefile)) {
			chmod($savefile, 0666);
			?>
		<SCRIPT language=javascript>window.opener.setImage('<?php echo $UPLOAD_BASE_URL.$HTTP_POST_FILES['FCKeditor_File']['name']; ?>') ; window.close();</SCRIPT>";
		<?php
		}
	} else {
		echo "Error : ";
		switch($HTTP_POST_FILES['FCKeditor_File']['error']) {
			case 0: //no error; possible file attack!
				echo "There was a problem with your upload.";
				break;
			case 1: //uploaded file exceeds the upload_max_filesize directive in php.ini
				echo "The file you are trying to upload is too big.";
				break;
			case 2: //uploaded file exceeds the MAX_FILE_SIZE directive that was specified in the html form
				echo "The file you are trying to upload is too big.";
				break;
			case 3: //uploaded file was only partially uploaded
				echo "The file you are trying upload was only partially uploaded.";
				break;
			case 4: //no file was uploaded
				echo "You must select an image for upload.";
				break;
			default: //a default error, just in case!  :)
				echo "There was a problem with your upload.";
				break;
		}
	}
	echo '<BR><BR><INPUT type="button" value=" Cancel " onclick="window.close()">';
} ?>
				</font></B></TD>
			</TR>
		</TABLE>
	</form></BODY>
</HTML>
