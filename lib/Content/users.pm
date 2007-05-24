################################################################################

sub get_item_of_users {

	my $item = sql_select_hash ("users");
	
	$_REQUEST {__read_only} ||= !($_REQUEST {__edit} || $item -> {fake} > 0);

	add_vocabularies ($item, 'roles');

	$item -> {path} = [
		{type => 'users', name => 'Пользователи'},
		{type => 'users', name => $item -> {label}, id => $item -> {id}},
	];
		
	return $item;
	
}

################################################################################

sub do_update_users {
	
	sql_do_update ('users', [qw(f i o label login id_role)]);

	$_REQUEST {_password} and sql_do ("UPDATE users SET password=PASSWORD(?) WHERE id=?", $_REQUEST {_password}, $_REQUEST {id});

}

################################################################################

sub validate_update_users {

	$_REQUEST {_id_role} or return "#_id_role#:Вы забыли указать роль";
	
	$_REQUEST {_label} = $_REQUEST {_f} . ' ' . $_REQUEST {_i} . ' ' . $_REQUEST {_o};

	vld_unique ('users');

	return $cnt ? 'duplicate_login' : undef;
	
}

################################################################################

sub do_create_users {

	$_REQUEST {id} = sql_do_insert ('users', {
		label => 'Фамилия И. О.',
	});
	
}

################################################################################

sub select_users {

	my $q = '%' . $_REQUEST {q} . '%';
	
	my $start = $_REQUEST {start} + 0;
	
	my ($users, $cnt)= sql_select_all_cnt (<<EOS, $q, $q, {fake => 'users'});
		SELECT
			users.*
			, roles.label AS role_label
		FROM
			users
			LEFT JOIN roles ON users.id_role = roles.id
		WHERE
			(users.label LIKE ? or users.login LIKE ?)
		ORDER BY
			users.label
		LIMIT
			$start, $$conf{portion}
EOS

	return {
		users => $users,
		cnt => $cnt,
		portion => $conf -> {portion},
	};	

}

1;
