<?php
function makeActionRegistrFO($tables){
	foreach ($tables as $i => $table){
		if($table['name']=='user'){break;}
	}
	$s="<?php
class registrFormAction{
	function Go(){
		if(isset(\$_REQUEST['login']) &&
		isset(\$_REQUEST['password']) &&
		isset(\$_REQUEST['password2']) &&
		isset(\$_REQUEST['email'])){
			\$login=mysql_escape_string(\$_REQUEST['login']);
			\$password=mysql_escape_string(\$_REQUEST['password']);
			\$password2=mysql_escape_string(\$_REQUEST['password2']);
			";
	foreach ($table['fields'] as $fname => $field){
		if($fname!='login' &&
		$fname!='password' &&
		$fname!='right'){		
	$s.="\$$fname=mysql_escape_string(\$_REQUEST['$fname']);
\$_SESSION['registr']['$fname']=\$$fname;
";
		}
	}
		$s.="\$capche=\$_REQUEST['capche'];
			
			\$_SESSION['registr']['login']=\$login;
			if(\$capche!=\$_SESSION['S_CAPCHE']){
				//ошибка capche
				\$_SESSION['registr']['error']='capche error';
				header('location: ?view=registrFormView');
			}
			if(\$password==\$password2){
				\$right=0;
				\$dbfront_user=new dbfront_user();
				\$dbfront_user->add(\$email, \$password, \$right, \$login, '', '', '', date('Y-m-d H:i:s'), 0, 0, 0);
			}else{
				//некорректный пароль
				\$_SESSION['registr']['error']='password error';
				header('location: ?view=registrFormView');
			}
		}
	}
}
?>";
	return $s;
}
?>