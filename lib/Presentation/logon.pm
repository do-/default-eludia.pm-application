################################################################################
sub draw_logon {

	return <<EOH;
	
		<script>
			
			function install_hta () {
			
				alert (document.location.href);
			
			}
			
		</script>
	
	
		<table height="75%" cellspacing=0 cellpadding=0 width="100%" class=bgr8 border=0>  
			<tr>
				<td align=middle>   
					<table cellspacing=0 cellpadding=0 border=0>      
						<form action=$_REQUEST{__uri} method=post autocomplete="off">
							<input type=hidden name=type value=logon>
							<input type=hidden name=_url value="$_REQUEST{_url}">
							<input type=hidden name=action value=execute>
							<input type=hidden name=redirect_params value="$_REQUEST{redirect_params}">
							<tr>
								<td width=1 bgcolor=black><img height=1 src="/i/0.gif" width=1 border=0></td>
								<td valign=top>
									<table height=32 cellspacing=0 cellpadding=0 border=0>
										<tr>
											<td bgcolor=#000000><img height=1 src="/i/0.gif" width=233 border=0></td>
										</tr>
										<tr>
											<td>
												<table height=68 cellspacing=0 cellpadding=0 width=244 border=0>
													<tr>
														<td bgcolor=#8e8e8e rowspan=2><img height=1 src="/i/0.gif" width=16 border=0></td>
														<td class=color0 bgcolor=#8e8e8e>&nbsp;<b>טלÿ:</b>&nbsp;</td>
														<td align=middle bgcolor=#8e8e8e><input style="width: 130px" size=15 name=login></td>
													</tr>
													<tr>
														<td class=color0 bgcolor=#8e8e8e>&nbsp;<b>ןאנמכü:</b>&nbsp;</td>
														<td align=middle bgcolor=#8e8e8e><input style="width: 130px" type=password size=15 name=password></td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td bgcolor=#d1d0d0>
												<table height=23 cellspacing=0 cellpadding=0 align=center border=0>
													<tr>
														<td align=right bgcolor=#d1d0d0><input class=txt7 type=submit value=דמעמגמ>&nbsp;</td>
<!--														
														<td align=left bgcolor=#d1d0d0>&nbsp;<input class=txt7 type=submit value=סבנמס></td>
-->														
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td bgcolor=#000000><img height=1 src="/i/0.gif" width=233 border=0></td>
										</tr>
									</table>
								</td>
								<td width=1 bgcolor=black><img height=1 src="/i/0.gif" width=1 border=0></td>
							</tr>
						</form>
					</table>
				</td>
			</tr>
		</table>
EOH
}
1;
