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
 * fck_editor.js: Main script that initializes the editor.
 *
 * Authors:
 *   Frederico Caldeira Knabben (fckeditor@fredck.com)
 */

// BEGIN: URLParams holds all URL passed parameters (like ?Param1=Value1&Param2=Value2)
var URLParams = new Object() ;

var aParams = document.location.search.substr(1).split('&') ;
for (i=0 ; i < aParams.length ; i++)
{
	var aParam = aParams[i].split('=') ;
	URLParams[aParam[0]] = aParam[1] ;
}
// END: URLParams

// Override some configurations
if (URLParams['Upload']) config.ImageUpload  = config.LinkUpload  = ( URLParams['Upload'] == 'true' ) ;
if (URLParams['Browse']) config.ImageBrowser = config.LinkBrowser = ( URLParams['Browse'] == 'true' ) ;

var BrowserInfo = new Object() ;
BrowserInfo.MajorVer = navigator.appVersion.match(/MSIE (.)/)[1] ;
BrowserInfo.MinorVer = navigator.appVersion.match(/MSIE .\.(.)/)[1] ;
BrowserInfo.IsIE55OrMore = BrowserInfo.MajorVer >= 6 || ( BrowserInfo.MajorVer >= 5 && BrowserInfo.MinorVer >= 5 ) ;

var bInitialized = false ;
var bDataLoaded  = false ;

function initEditor()
{
	if (! bInitialized) 
	{
		bInitialized = true ;	
		
		loadToolbarSet() ;
		loadToolbarSourceSet() ;

		objContent.BaseURL = config.BaseUrl ;
	}

	if (! bDataLoaded && ! objContent.Busy)
	{
		bDataLoaded = true ;

		objContent.DOM.body.onpaste = onPaste ;
		objContent.DOM.createStyleSheet(config.EditorAreaCSS) ;
		setLinkedField() ;
	}
}

// Method: loadToolbarSet()
// Description: Loads a toobar buttons set from an array inside the Toolbar holder.
// Author: FredCK
function loadToolbarSet()
{
	var sToolBarSet = URLParams["Toolbar"] == null ? "Default" : URLParams["Toolbar"] ;

	// FredCK: Toobar holder (DIV)
	var oToolbarHolder = document.getElementById("divToolbar") ;

	var oToolbar = new TBToolbar() ;
	oToolbar.LoadButtonsSet( sToolBarSet ) ;
	oToolbarHolder.innerHTML = oToolbar.GetHTML() ;
}

function loadToolbarSourceSet()
{
	// FredCK: Toobar holder (DIV)
	var oToolbarHolder = document.getElementById("divToolbarSource") ;

	var oToolbar = new TBToolbar() ;
	oToolbar.LoadButtonsSet( "Source" ) ;
	oToolbarHolder.innerHTML = oToolbar.GetHTML() ;
}

function switchEditMode()
{
	var bSource = (trSource.style.display == "none") ;
	
	if (bSource) 
		txtSource.value = objContent.DOM.body.innerHTML ;
	else
	{
		objContent.DOM.body.innerHTML = "<div id=__tmpFCKRemove__>&nbsp;</div>" + txtSource.value ;
		objContent.DOM.getElementById('__tmpFCKRemove__').removeNode(true) ;
	}
		
	trEditor.style.display = bSource ? "none" : "inline" ;
	trSource.style.display = bSource ? "inline" : "none" ;
	
	events.fireEvent('onViewMode', bSource) ;
}

// setValue(): called from reset() to make a select list show the current font
// or style attributes
function selValue(el, str, text)
{
	//if (!RichEditor.txtView) return;      // Disabled in View Source mode
	for (var i = 0; i < el.length; i++) 
	{
		if (((text || !el[i].value) && el[i].text == str) || ((!text || el[i].value) && el[i].value == str)) 
		{
			el.selectedIndex = i;
			return;
		}
	}
	el.selectedIndex = 0;
}

var oLinkedField = null ;
function setLinkedField()
{
	if (! URLParams['FieldName']) return ;
	
	oLinkedField = parent.document.getElementsByName(URLParams['FieldName'])[0] ;
	
	if (! oLinkedField) return ;

	// __tmpFCKRemove__ added and removed to solve DHTML component error when loading "<p><hr></p>"
	objContent.DOM.body.innerHTML = "<div id=__tmpFCKRemove__>&nbsp;</div>" + oLinkedField.value ;
	objContent.DOM.getElementById('__tmpFCKRemove__').removeNode(true) ;
	
	var oForm = oLinkedField.form ;
	
	if (!oForm) return ;

	// Attaches the field update to the onsubmit event
	oForm.attachEvent("onsubmit", setFieldValue) ;
	
	// Attaches the field update to the submit method (IE doesn't fire onsubmit on this case)
	if (! oForm.updateFCKEditor) oForm.updateFCKEditor = new Array() ;
	oForm.updateFCKEditor[oForm.updateFCKEditor.length] = setFieldValue ;
	if (! oForm.originalSubmit)
	{
		oForm.originalSubmit = oForm.submit ;
		oForm.submit = function()
		{
			if (this.updateFCKEditor)
			{
				for (var i = 0 ; i < this.updateFCKEditor.length ; i++)
				{
					this.updateFCKEditor[i]() ;
				}
			}
			this.originalSubmit() ;
		}
	}
}

function setFieldValue()
{
	if (trSource.style.display != "none")
	{
		switchEditMode() ;
	}

	if (config.EnableXHTML)
	{
		window.status = lang["ProcessingXHTML"] ;
		oLinkedField.value = getXhtml( objContent.DOM.body ) ;
		window.status = 'Done' ;
	}
	else
		oLinkedField.value = objContent.DOM.body.innerHTML ;
}

function onPaste()
{
	if (config.ForcePasteAsPlainText)
	{
		pastePlainText() ;	
		return false ;
	}
	else if (config.AutoDetectPasteFromWord && BrowserInfo.IsIE55OrMore)
	{
		var sHTML = GetClipboardHTML() ;
		var re = /<\w[^>]* class="?MsoNormal"?/gi ;
		if ( re.test( sHTML ) )
		{
			if ( confirm( lang["PasteWordConfirm"] ) )
			{
				cleanAndPaste( sHTML ) ;
				return false ;
			}
		}
	}
	else
		return true ;
}