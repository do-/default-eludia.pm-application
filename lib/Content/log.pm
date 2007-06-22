################################################################################

sub get_item_of_log {

	my $item = sql_select_hash ('SELECT *, DATE_FORMAT(dt, \'%d.%m.%Y %H:%i:%S\') AS dt FROM log WHERE id = ?', $_REQUEST {id});

	add_vocabularies ($item, 'users');

	$item -> {path} = [
		{type => 'log', name => 'Log'},
		{type => 'log', name => $item -> {label}, id => $item -> {id}},
	];
	
	my $_REQUEST;
	eval $item -> {params};
	
	my @params = ();
	foreach my $key (sort keys %$_REQUEST) {
		next if $key =~ /^__/;
		next if $key !~ /^_/;
		next if $key eq '_salt';
		push @params, {label => $key, value => $_REQUEST -> {$key}},
	}
	
	$item -> {params_list} = \@params;

	return $item;
	
}

################################################################################

sub select_log {

	$_REQUEST {__infty} = 1;

	my $start = $_REQUEST {start} + 0;

	my $user_filer = $_REQUEST {id_user} ? "AND log.id_user = $_REQUEST{id_user}" : '';
	
	my ($object_type, $object_id) = split /\./, $_REQUEST {object_type};
	
	my $type_filer = $object_type ? "AND log.type      = '$object_type'" : '';
	my $id_filer   = $object_id ?   "AND log.id_object = $object_id" : '';

	my ($log, $cnt) = sql_select_all_cnt (<<EOS);
		SELECT
			log.*
			, DATE_FORMAT(log.dt, '%d.%m.%Y %H:%i:%s') AS dt
			, users.label
		FROM 		
			log
			INNER JOIN users ON log.id_user = users.id
		WHERE
			1=1
			$user_filer
			$type_filer
			$id_filer
		ORDER BY 		
			log.id DESC
		LIMIT
			$start, 50 #$$conf{portion}
EOS
	
	return {
		log => $log,
		cnt => $cnt,
		users => sql_select_all ('SELECT id, label FROM users WHERE fake = 0 ORDER BY label'),
		portion => 50
	};

}

1;
