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
					label => '�������',
					size  => 30,
				},
				{
					name  => 'i',
					label => '���',
					size  => 30,
				},
				{
					name  => 'o',
					label => '��������',
					size  => 30,
				},
			],
			{
				name  => 'label',
				label => '���',
				type  => 'static',
			},
			{
				name  => 'login',
				mandatory  => 1,
				label => '&login',
			},
			{
				name  => 'password',
				label => '�����&�',
				type  => 'password',
			},
			{
				name   => 'id_role',
				label  => '����',
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
		
			['���', '����', 'login', ''],

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
							label => '�������',
							href => "/?type=users&action=delete&id=$$i{id}",
							confirm => "������� ������������ $$i{label}?",
							off => $i -> {id} == $_USER -> {id},
						},
					]
				)
				
			},
			
			$data -> {users},			
			
			{		
			
				title => {label => '������������'},
		
				top_toolbar => [
				
					{},
					
					{
						icon => 'create',
						label => '&��������',
						href => "?type=users&action=create",
					},
		
					{
						type   => 'input_text',
						label  => '������',
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
