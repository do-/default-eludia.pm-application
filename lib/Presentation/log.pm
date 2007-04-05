################################################################################

sub draw_log {
	
	my ($data) = @_;
	
	return
	
		draw_hr (height => 10)
		
		.
	
		draw_window_title ({
			label => 'Протокол'
		})
	
		.
		
		draw_toolbar (
		
			{keep_params => ['type']},
			
			draw_toolbar_pager ({
				cnt    => 0 + @{$data -> {log}},
				total  => $data -> {cnt},
				portion => $data -> {portion}
			})
			
			,

			draw_toolbar_input_text ({
				icon   => 'tv',
				label  => 'Тип',
				name   => 'object_type',
				keep_params => [],
			}),
			
			draw_toolbar_input_select ({
				name => 'id_user',
				values => $data -> {users},
				empty => 'Все пользователи',
			})			
			
		)			
		
		.

		draw_table (
			
			['Дата', 'Пользователь', 'IP', 'Действие', 'Тип', 'ID', 'Ошибка'],
		
			sub {
			
				delete $i -> {id_user} if $_REQUEST {_id_user};
			
				$i -> {ip} .= " ($$i{ip_fw})" if $i -> {ip_fw};
			
				draw_text_cells ([
					$i -> {dt},
					{
						label => $i -> {label},
						href  => {id_user => $i -> {id_user}},
					},
					$i -> {ip},
					$i -> {action},
					{
						label => $i -> {type},
						href  => {object_type => $i -> {type}},
					},
					$i -> {id_object},
					$i -> {error},
				])
			},
			
			$data -> {log}
			
		)
		
}


1;
