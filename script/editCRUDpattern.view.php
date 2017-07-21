<?php
function makeEditCRUDclass($crud, $tables){
	$viewName=translit(iconv('utf-8', 'cp1251', $crud['name']));
	$mainTable=$tables[$crud['content']['mainTable']];
	$s="<?php
class ".$viewName."EditBO{
	var \$id;
	var \$db$mainTable[name];
	var \$$mainTable[name];
";
	//соберём lookUp таблицы
	foreach ($crud['content']['view'] as $fname => $field) {
		if($field['show']){
			if($fname=='ID'){
				$type='int';
			}else{
				$type=$mainTable['fields'][$fname]['type'];
			}
			if($type=='int' && $field['lookup']>0){
				$lookUpTable=$tables[$field['lookup']];
				$s.="var \$db$lookUpTable[name];
var \$list$lookUpTable[name];
";
			}
		}
	}
	$s.="function ".$viewName."EditBO(){
		\$this->id=\$_REQUEST['id']*1;
		\$this->db$mainTable[name] = new db$mainTable[name]();
		\$this->$mainTable[name] = \$this->db$mainTable[name]->get(\$this->id);
		
";
		//соберём lookUp таблицы
		foreach ($crud['content']['view'] as $fname => $field) {
			if($field['show']){
				if($fname=='ID'){
					$type='int';
				}else{
					$type=$mainTable['fields'][$fname]['type'];
				}
				if($type=='int' && $field['lookup']>0){
					$lookUpTable=$tables[$field['lookup']];
					$s.="\$this->db$lookUpTable[name] = new db$lookUpTable[name]();
//получаем лист для lookUp
		\$this->list$lookUpTable[name]=\$this->db$lookUpTable[name]->load('','',0,0);";
				}
			}
		}
		$s.="
	}
	function Paint(){
		?>
		<a href='?view=".$viewName."ViewBO'>К списку</a>
		<table border=\"1\">
		<form method=\"POST\" enctype=\"multipart/form-data\" action=\"?view=".$viewName."EditBO&action=update".$viewName."ActionBO&id=<?=\$this->id?>\">
";
		foreach ($crud['content']['view'] as $fname => $field) {
			if($field['show']){
				$s.="
			<tr><td>$fname</td><td>";
				if($fname=='ID'){
					$type='int';
					$fname='id';
				}else{
					$type=$mainTable['fields'][$fname]['type'];
				}
				switch ($type){
					case 'on_off':
						$s.="<input type=checkbox name=\"$fname\" value='1' <?php if(\$this->$mainTable[name]"."['$fname']!=0){ ?> checked<?php } ?>>";
					break;
					case 'int':
						//проверить, не является ли lookUp
						if($field['lookup']>0){
							$lookUpTable=$tables[$field['lookup']];
							$s.="<?php echo(\$this->lookUp(\$this->list$lookUpTable[name], \$this->$mainTable[name]"."['$fname'], '$field[lookupfield]', '$fname'));?>";
						}else{
							$s.="<input type=\"text\" name=\"$fname\" value=\"<?php echo(\$this->$mainTable[name]"."['$fname']);?>\">";
						}
					break;
					case 'string':
						$s.="<input type=\"text\" name=\"$fname\" value=\"<?php echo(htmlspecialchars(\$this->$mainTable[name]"."['$fname']));?>\">";
					break;
					case 'date':
						$s.="<input type=\"text\" name=\"$fname\" id=\"$fname"."_fd\" value=\"<?php echo(\$this->$mainTable[name]"."['$fname']);?>\"><img src='images/b_calendar.png' onclick=\"openCalendar('', '', '$fname"."_fd', 'datetime', '$fname"."_fd');\">";
					break;
					case 'text':
						$s.="<textarea name=\"$fname\"><?php echo(\$this->$mainTable[name]"."['$fname']);?></textarea>";
					break;
					case 'file':
						$s.="<?php echo(\$this->photo(\$this->id, '$fname'));?><br><input type=\"file\" name=\"$fname\">";
					break;
				}
				$s.="</td></tr>";
			}
		}
		$s.="
		<tr><td colspan=\"2\"><input value=\" O.K. \" type=\"submit\"></td></tr>
		</form>
		</table>
		<?php
	}
	function lookUp(&\$list, \$id, \$field_name, \$name){
		\$s=\"<select name='\$name'>
		<option value=0> --- </option>
\";
		\$fna=explode(':',\$field_name);
		if(is_array(\$list)){
			foreach (\$list as \$rec){
				\$s.=\"<option value='\$rec[id]'\";
				if(\$rec['id']==\$id){
					\$s.=\" selected\";
				}
				\$s.='>';
				foreach (\$fna as \$ofn){
					\$s.=\$rec[\$ofn].' ';
				}
				\$s.=\"</option>
\";
			}
		}
		\$s.=\"</select>
\";
		return \$s;
	}
	function photo(\$photo, \$name){
		\$path=photoPath(\$photo).'/'.\$name;
		if(file_exists(\$path)){
			return \"<img src='\$path'>\";
		}else{
			return \"<img src='./photo/noimage.png'>\";
		}
	}
}
?>";
	return $s;
}
?>