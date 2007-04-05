################################################################################

sub select_log {

	my $start = $_REQUEST {start} + 0;

	my $user_filer = $_REQUEST {id_user}     ? "AND log.id_user = $_REQUEST{id_user}" : '';
	my $type_filer = $_REQUEST {object_type} ? "AND log.type    = '$_REQUEST{object_type}'" : '';

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
		ORDER BY 		
			log.id DESC
		LIMIT
			$start, 5 #$$conf{portion}
EOS
	
	return {
		log => $log,
		cnt => $cnt,
		users => sql_select_all ('SELECT id, label FROM users WHERE fake = 0 ORDER BY label'),
		portion => 5
	};

}

1;
