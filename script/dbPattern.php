<?php
function makeDBclass($table){
$s='class db'.$table['name'].'{
	function count($where=""){
		$sql="SELECT count(*) as cnt FROM `'.$table['name'].'`";
		if($where!=""){
			$sql.=" WHERE $where";
		}
		$r=mysql_query($sql);
		return mysql_result($r,0,"cnt");
	}
	function load($where="", $order="", $start=0, $limit=0){
		$sql="SELECT * FROM `'.$table['name'].'`";
		if($where!=""){
			$sql.=" WHERE $where";
		}
		if($order!=""){
			$sql.=" ORDER $order";
		}
		if($limit>0){
			$sql.=" LIMIT $start, $limit";
		}
		$r=mysql_query($sql);
		$n=mysql_num_rows($r);
		$list=array();
		for($i=0;$i<$n;$i++){
			$id=mysql_result($r,$i,"id");
';			
			foreach ($table['fields'] as $field_name => $field){
				$s.="\$$field_name = mysql_result(\$r,\$i,'$field_name');
";
			}
			$s.="\$list[]=array(\"id\"=>\$id";
			foreach ($table['fields'] as $field_name => $field){
				$s.=", \"$field_name\"=>\$$field_name";
			}
			$s.=');
		}
		return $list;
	}
	function get($id){
		$sql="SELECT * FROM `'.$table['name'].'` WHERE id=$id";
		$r=mysql_query($sql);
		$n=mysql_num_rows($r);
		if($n>0){
			$id=mysql_result($r,0,"id");
';
			foreach ($table['fields'] as $field_name => $field){
				$s.="\$$field_name = mysql_result(\$r,\$i,'$field_name');
";
			}
			$s.='return array("id"=>$id';
			foreach ($table['fields'] as $field_name => $field){
				$s.=", \"$field_name\"=>\$$field_name";
			}
			$s.=');
		}else{
			return false;
		}
	}
	function add(';
	$d='';
	foreach ($table['fields'] as $field_name => $field){
		$s.=$d.'$'.$field_name;
		$d=', ';
	}
	$s.='){
		$sql="INSERT INTO `'.$table['name'].'`(';
	$d='';
		foreach ($table['fields'] as $field_name => $field){
			$s.=$d.'`'.$field_name.'`';
			$d=', ';
		}
		$s.=') VALUES(';
		$d='';
		foreach ($table['fields'] as $field_name => $field){
			$s.=$d.'\'$'.$field_name.'\'';
			$d=', ';
		}
		$s.=')";
		mysql_query($sql);
		return mysql_insert_id();
	}
	function del($id){
		$sql="DELETE FROM `'.$table['name'].'` WHERE id=$id";
		mysql_query($sql);
	}
	function update($id';
	foreach ($table['fields'] as $field_name => $field){
		$s.=', $'.$field_name;
	}
	$s.='){
		$sql="UPDATE `'.$table['name'].'` SET ";
		$d=\'\';';
		foreach ($table['fields'] as $field_name => $field){
			$s.="if(\$$field_name!==null){
				\$sql.=\$d.' `$field_name`=\"'.\$$field_name.'\"';
				\$d=', ';
			}";
		}
		$s.='
		$sql.=" WHERE id=$id";
		mysql_query($sql);
	}
}';
		return $s;
}
?>