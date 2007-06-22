################################################################################

sub draw_item_of_log {

	my ($data) = @_;
	
	draw_form ({}, $data,
		[
			{
				name  => 'dt',
				label => 'Дата',
			},
			{
				name  => 'id_user',
				label => 'Пользователь',
				values => $data -> {users},
			},
			{
				name  => 'type',
				label => 'Тип',
			},
			{
				name  => 'id_object',
				label => "ID объекта",
				href  => "/?type=$$data{type}&id=$$data{id_object}&__popup=1",
				target => '_blank',
			},
			{
				name  => 'action',
				label => 'Действие',
			},
			{
				name  => 'error',
				label => 'Ошибка',
				off   => !$data -> {error},
			},
		]
	)
	
	.
	
	draw_table (
	
		['Имя', 'Значение'],
		
		sub {
		
			draw_text_cells ({}, [
				$i -> {label},
				{
					label => $i -> {value},
					max_len => 120,
				},
			])
		
		},
		
		$data -> {params_list},
		
		{
			title => {label => 'Параметры'},
			off   => 0 == @{$data -> {params_list}},
		}
	
	)
	
	
}

################################################################################

sub draw_log {
	
	my ($data) = @_;
	
	return
	
		draw_table (
			
			['Дата', 'Пользователь', 'IP', 'Действие', 'Тип', 'ID', 'Ошибка'],
		
			sub {
			
				delete $i -> {id_user} if $_REQUEST {_id_user};
			
				$i -> {ip} .= " ($$i{ip_fw})" if $i -> {ip_fw};
			
				draw_text_cells ([
					{
						label => $i -> {dt},
						href  => "/?type=log&id=$$i{id}&__popup=1",
						target => '_blank',
					},
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
					{
						label  => $i -> {id_object},
						href   => "/?type=$$i{type}&id=$$i{id_object}&__popup=1",
						target => '_blank',
					},
					$i -> {error},
				])
			},
			
			$data -> {log},
			
			{					
				
				title => {label => 'Протокол'},
				
				top_toolbar => [

					{
						keep_params => ['type'],
					},
					
					{
						type    => 'pager',
						cnt     => 0 + @{$data -> {log}},
						total   => $data -> {cnt},
						portion => $data -> {portion}
					},
		
					{
						type    => 'input_text',
						label   => 'Тип',
						keep_params => [],
						name    => 'object_type',
					},
		
					{				
						type    => 'input_select',
						name => 'id_user',
						values => $data -> {users},
						empty => '[Все пользователи]',
					},
				
				],

			},
			
		)
		
}


1;
