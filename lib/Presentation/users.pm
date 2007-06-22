################################################################################

sub draw_item_of_users {

	my ($data) = @_;	
	
	draw_form ({
	
		right_buttons => [ del ($data) ],
	
	}, $data,
		[
			[
				{
					name  => 'f',
					label => 'Фамилия',
					size  => 30,
				},
				{
					name  => 'i',
					label => 'Имя',
					size  => 30,
				},
				{
					name  => 'o',
					label => 'Отчество',
					size  => 30,
				},
			],
			{
				name  => 'label',
				label => 'ФИО',
				type  => 'static',
			},
			{
				name  => 'login',
				mandatory  => 1,
				label => '&login',
			},
			{
				name  => 'password',
				label => 'парол&ь',
				type  => 'password',
			},
			{
				name   => 'id_role',
				label  => 'Роль',
				type   => 'radio',
				values => $data -> {roles},
			},
		]
	)
	
}

################################################################################

sub draw_users {
	
	my ($data) = @_;
	
	return
	
		draw_table (
		
			['ФИО', 'Роль', 'login', ''],

			sub {
					
				draw_text_cells ({
					href => "/?type=users&id=$$i{id}",
				}, [
					$i -> {label},
					$i -> {role_label},
					$i -> {login},
				])
				
				.
							
				draw_row_buttons ({},
					[
						{
							icon => 'delete',
							label => 'Удалить',
							href => "/?type=users&action=delete&id=$$i{id}",
							confirm => "Удалить пользователя $$i{label}?",
							off => $i -> {id} == $_USER -> {id},
						},
					]
				)
				
			},
			
			$data -> {users},			
			
			{		
			
				title => {label => 'Пользователи'},
		
				top_toolbar => [
				
					{},
					
					{
						icon => 'create',
						label => '&Добавить',
						href => "?type=users&action=create",
					},
		
					{
						type   => 'input_text',
						label  => 'Искать',
						name   => 'q',
					},
					
					{
						type    => 'pager',
						cnt     => 0 + @{$data -> {users}},
						total   => $data -> {cnt},
						portion => $data -> {portion},
					},
					
					fake_select (),
					
				],
			
			},			
			
		)
		
}

1;
