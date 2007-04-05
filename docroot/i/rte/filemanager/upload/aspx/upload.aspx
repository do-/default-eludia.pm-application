<%@ Page Language="C#" %>
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
 * upload.aspx: Basic fil upload manager for the editor. You have
 *   to have set a directory called "UserImages" in the root folder
 *   of your web site.
 *
 * Authors:
 *   Frederico Caldeira Knabben (fckeditor@fredck.com)
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
<SCRIPT runat="server">
	private void Page_Load(object sender, System.EventArgs e)
	{
		if (Request.Files.Count > 0)
		{
			string sXMLPath = Server.MapPath("./") + "upload.xml" ;

			System.Xml.XmlDocument oXMLDoc = new System.Xml.XmlDocument() ;
			oXMLDoc.Load(sXMLPath) ;
			System.Xml.XmlNode oNode = oXMLDoc.SelectSingleNode("/FCKeditor_Upload/FileNameCounter") ;

			int iCounter = int.Parse( oNode.InnerText ) + 1 ;

			oNode.InnerText = iCounter.ToString() ;

			oXMLDoc.Save(sXMLPath) ;

 			oNode   = null ;
			oXMLDoc = null ;

			System.Web.HttpPostedFile oFile = Request.Files.Get("FCKeditor_File") ;
			
			string sFileURL  = "/UserImages/" + iCounter.ToString().PadLeft(8,'0') + System.IO.Path.GetExtension(oFile.FileName) ;
			string sFilePath = Server.MapPath(sFileURL) ;
			
			oFile.SaveAs(sFilePath) ;
			
			Response.Write("<SCRIPT language=javascript>window.opener.setImage('" + sFileURL + "') ; window.close();</" + "SCRIPT>") ;
		}
	}
</SCRIPT>
