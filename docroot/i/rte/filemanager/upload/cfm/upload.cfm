<!--
 * FCKeditor - The text editor for internet
 * Copyright (C) 2003 Frederico Caldeira Knabben
 *
 * Licensed under the terms of the GNU Lesser General Public License
 * (http://www.opensource.org/licenses/lgpl-license.php)
 *
 * For further information go to http://www.fredck.com/FCKeditor/ 
 * or contact fckeditor@fredck.com.
 *
 * upload.cfm: Basic file upload manager for the editor. You have
 *   to have set a directory called "userimages" in the root folder
 *   of your web site.
 *
 * Authors:
 *   John Watson (john@themedialounge.net)
-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<TITLE>FCKeditor - File Upload</TITLE>
	</HEAD>
	<BODY>
		<TABLE height="100%" width="100%">
			<TR>
				<TD align=center valign=middle>
					Upload in progress...
				</TD>
			</TR>
		</TABLE>
	</BODY>
</HTML>

<cfparam name="usersdirectory" default="userimages">
<cfset thisPath="#ExpandPath("/")#">
<cfset mapDirectory="#thisPath##usersdirectory#">
<cffile action="UPLOAD" filefield="FCKeditor_File" destination="#mapDirectory#" nameconflict="overwrite">
<cfset thefilename = file.serverfile>
<cfoutput><SCRIPT language=javascript>window.opener.setImage('#thefilename#') ; window.close();</SCRIPT></cfoutput>