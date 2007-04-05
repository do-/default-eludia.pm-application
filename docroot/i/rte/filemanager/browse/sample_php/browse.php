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
 * browse.php: Browse function.
 *
 * Authors:
 *   Frederic TYNDIUK (http://www.ftls.org/ - tyndiuk[at]ftls.org)
 */

// Init var :

	$IMAGES_BASE_URL = '/FCKeditor/userimages/';
	$IMAGES_BASE_DIR = getenv("DOCUMENT_ROOT").$IMAGES_BASE_URL;

// End int var

// Thanks : php dot net at phor dot net
function walk_dir($path) {
	if ($dir = opendir($path)) {
		while (false !== ($file = readdir($dir)))
		{
			if ($file[0]==".") continue;
			if (is_dir($path."/".$file))
				$retval = array_merge($retval,walk_dir($path."/".$file));
			else if (is_file($path."/".$file))
				$retval[]=$path."/".$file;
			}
		closedir($dir);
		}
	return $retval;
}

function CheckImgExt($filename) {
	$img_exts = array("gif","jpg", "jpeg","png");
	foreach($img_exts as $this_ext) {
		if (preg_match("/\.$this_ext$/", $filename)) {
			return TRUE;
		}
	}
	return FALSE;
}

foreach (walk_dir($IMAGES_BASE_DIR) as $file) {
	$file = preg_replace("#//+#", '/', $file);
	$IMAGES_BASE_DIR = preg_replace("#//+#", '/', $IMAGES_BASE_DIR);
	$file = preg_replace("#$IMAGES_BASE_DIR#", '', $file);
	if (CheckImgExt($file)) {
		$html_img_lst .= "<a href=\"javascript:getImage('$file');\">$file</a><br>\n";
	}
}

?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE>Image Browser</TITLE>
		<LINK rel="stylesheet" type="text/css" href="../../../css/fck_dialog.css">
		<SCRIPT language="javascript">
var sImagesPath  = "<?php echo $IMAGES_BASE_URL; ?>";
var sActiveImage = "" ;

function getImage(imageName)
{
	sActiveImage = sImagesPath + imageName ;
	imgPreview.src = sActiveImage ;
}

function ok()
{	
	window.setImage(sActiveImage) ;
	window.close() ;
}
		</SCRIPT>
	</HEAD>
	<BODY bottommargin="5" leftmargin="5" topmargin="5" rightmargin="5">
<TABLE cellspacing="1" cellpadding="1" border="0" width="100%" class="dlg" height="100%">
	<TR height="100%">
		<TD>
			<TABLE cellspacing="0" cellpadding="0" width="100%" border="0" height="100%">
				<TR>
					<TD width="45%" valign="top">
						<table cellpadding="0" cellspacing="0" height="100%" width="100%">
							<tr>
								<td width="100%">File : </td>
							</tr>
							<tr height="100%">
								<td>
									<DIV class="ImagePreviewArea"><? echo $html_img_lst ?></DIV>
								</td>
							</tr>
						</table>
					</TD>
					<TD width="10%" >&nbsp;&nbsp;&nbsp;</TD>
					<TD>
						<table cellpadding="0" cellspacing="0" height="100%" width="100%">
							<tr>
								<td width="100%">Preview : </td>
							</tr>
							<tr>
								<td height="100%" align="center" valign="middle">
									<DIV class="ImagePreviewArea"><IMG id="imgPreview" border=1"></DIV>
								</td>
							</tr>
						</table>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD align="center">
			<INPUT style="WIDTH: 80px" type="button" value="OK"     onclick="ok();"> &nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT style="WIDTH: 80px" type="button" value="Cancel" onclick="window.close();"><BR>
		</TD>
	</TR>
</TABLE>
	</BODY>
</HTML>
