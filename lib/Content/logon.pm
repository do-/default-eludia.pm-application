################################################################################

sub select_logon {}

################################################################################

sub do_execute_logon {
	our $_USER = {};
	$_USER -> {id} = sql_select_array ("SELECT id FROM users WHERE login = ? AND password = OLD_PASSWORD(?)", $_REQUEST {login}, $_REQUEST {password});
	$_USER -> {id} or return;
	$_REQUEST {sid} = sql_select_array ("select floor(rand() * 9223372036854775807)");
	sql_do ("DELETE FROM sessions WHERE id_user = ?", $_USER -> {id});
	sql_do ("INSERT INTO sessions (id, id_user) VALUES (?, ?)", $_REQUEST {sid}, $_USER -> {id});
	delete $_REQUEST {type};
	delete $_REQUEST {login};
	delete $_REQUEST {password};
}

1;