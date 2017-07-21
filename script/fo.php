<?php
session_start();
require_once('connect_db.php');
require_once('authFO.php');
require_once('lib.php');
requireDir('Models/');
requireDir('View/');
requireDir('Action/');

//проверяем попытку авторизации
if(isset($_REQUEST['login']) && isset($_REQUEST['password'])){
	loginFO($_REQUEST['login'], $_REQUEST['password']);
}

$menu = new menuFO();

if(isset($_REQUEST['action'])){
	//проверит авторизацию
	if(checkAuthFO($_SESSION['front_user_id'], $_REQUEST['action'])){
		eval("\$action=new $_REQUEST[action]();");
		$action->Go();
	}
}
if(isset($_REQUEST['view'])){
	//проверит авторизацию
	if(checkAuthFO($_SESSION['front_user_id'], $_REQUEST['view'])){
		eval("\$view=new $_REQUEST[view]();");
	}
}else{
	$view=null;
}
?>
<html>
<head>
<title>Tarion</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
</head>
<body>
<link rel="stylesheet" type="text/css" href="style.css" />
<script src="tbl_change.js"></script>
<?php $menu->Paint();?>
<td align="right">
<input type="button" onclick="document.getElementById('authTable').style.display='block';" value="Авторизация">
</td>
</tr>
</table>
<table id='authTable' style="position:absolute;top:300px;left:300px;width:150px;background-color:Aqua;display:none;">
<form method="POST" action="">
<tr><td>login:</td><td><input type="text" name="login" style="width:80px;height:18px;"></td></tr>
<tr><td>password:</td><td><input type="password" name="password" style="width:80px;height:18px;"></td></tr>
<tr><td colspan="2" align="center"><input type="submit" value="Вход" style="height:18px;"></td></tr>
<tr><td colspan="2" align="center"><a href="?view=registrFormView">Регистрация</a></td></tr>
</form>
</table>
<script>
document.getElementById('authTable').style.left=Math.round(document.body.clientWidth/2 - 150/2);
</script>

<br>
<table width="100%" border="1">
<tr></tr>
	<td valign="top"><?php if($view!=null){$view->Paint();}?></td>
</tr>
</table>
</body>
</html>