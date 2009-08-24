################################################################################

sub select_users {
	
	my $item = {
		portion => $conf -> {portion},
	};
	
	my $filter = '';
	my @params = ();
	
	if ($_REQUEST {q}) {		
		$filter .= ' AND users.label LIKE ?';
		push @params, '%' . $_REQUEST {q} . '%';		
	}

	my $start = $_REQUEST {start} + 0;

	($item -> {users}, $item -> {cnt}) = sql_select_all_cnt (<<EOS, @params, {fake => 'users'});
		SELECT
			users.*
			, roles.label AS role_label
		FROM
			users
			LEFT JOIN roles ON users.id_role = roles.id
		WHERE
			1=1
			$filter
		ORDER BY
			users.label
		LIMIT
			$start, $$item{portion}
EOS

	return $item;

}

################################################################################

sub get_item_of_users {

	my $item = sql_select_hash ("users");
	
	$_REQUEST {__read_only} ||= !($_REQUEST {__edit} || $item -> {fake} > 0);

	add_vocabularies ($item, 'roles');

	$item -> {path} = [
		{type => 'users', name => '������������'},
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

	$_REQUEST {_f} =~ /^[�-ߨ][�-��]+$/ or return "#_f#:������������ �������";
	$_REQUEST {_i} =~ /^[�-ߨ][�-��]+$/ or return "#_i#:������������ ���";
	$_REQUEST {_o} =~ /^[�-ߨ][�-��]*[��]$/ or return "#_o#:������������ ��������";

	$_REQUEST {_label} = $_REQUEST {_f} . ' ' . $_REQUEST {_i} . ' ' . $_REQUEST {_o};

	$_REQUEST {_id_role} or return "#_id_role#:�� ������ ������� ����";	

	vld_unique ('users', {field => 'login'}) or return "#_login#:Login '$_REQUEST{_login}' ��� �����";
	
	undef;
	
}

################################################################################

sub do_create_users {

	$_REQUEST {id} = sql_do_insert ('users', {
		label => '������� �. �.',
	});
	
}

1;
