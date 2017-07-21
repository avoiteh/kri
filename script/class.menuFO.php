<?php
class menuFO{
	var $menuTree;
	function Paint(){
		$sql="SELECT * FROM front_modules";
		$r=mysql_query($sql);
		$n=mysql_num_rows($r);
		$this->menuTree=array();
		for($i=0;$i<$n;$i++){
			$id=mysql_result($r,$i,'id');
			$parent=mysql_result($r,$i,'parent');
			$module=mysql_result($r,$i,'module');
			$title=mysql_result($r,$i,'title');
			$type=mysql_result($r,$i,'type');
			//проверяем права доступа
			if(checkAuthFO($_SESSION['front_user_id']*1,$module)){
				$this->menuTree[$id]=array("parent"=>$parent, "name"=>$title, "type"=>$type, "module"=>$module);
			}
		}
		echo $this->TreePaint(0,0);
	}
	function TreePaint($parent,$level){
		$s='';
		$i=0;
		$j=0;
		$node=array();
		foreach($this->menuTree as $id => $punkt){
			if($punkt['parent']==$parent){
				$node[$j]=array("id"=>$id, "punkt"=>$punkt);
				$j++;
			}
		}
		$max=$j-1;
		//если уровень нулевой, то пункты меню должны отображаться на горизонтальном слое,
		//статически "прижатом" к топу страницы
		if($level==0){
			$s.="<table style='position:absolute;left:0px;top:0px;width:100%' bgcolor='Aqua' border=0 cellspacing=0 cellpadding=0>
<tr>";
			foreach($node as $i => $punkt){
				if($punkt['punkt']['type']=='menu'){
					/*
					меню должна показываться в виде ссылки, если оно ведёт на CRUD или TreeCRUD
					*/
					$next=$this->checkCRUDByParent($punkt['id']);
					$ts=$this->TreePaint($punkt['id'],$level+1);
					if($next===false){
						if($ts!=''){
							$s.="<td onmouseover=\"document.getElementById('mp$i').style.display='block';\" onmouseout=\"document.getElementById('mp$i').style.display='none';\" style='width:150px;'>".$punkt['punkt']['name'];
						}else{
							$s.="<td style='width:150px;'>".$punkt['punkt']['name'];
						}
					}else{
						$link=$this->menuTree[$next]['module'];
						$s.="<td><a href='?view=$link'>".$punkt['punkt']['name']."</a></td>";
					}
					if($ts!=''){
						$s.="<div id='mp$i' style='position:absolute; left:".(10+$i*150)."px;top:20px; display:none;background-color:Aqua;border:#00cccc 1px solid;'>$ts</div>";
					}
					$s.="</td>";
				}
			}
			//$s.="<td>&nbsp;</td></tr></table>";
		}else{
			foreach($node as $i => $punkt){
				if($punkt['punkt']['type']=='menu'){
					$s.="<div style='cursor:pointer; width:100%; background-color:#00ffff;' onmouseover='this.style.backgroundColor=\"#00cccc\";' onmouseout='this.style.backgroundColor=\"#00ffff\";'>";
					//
					//меню должна показываться в виде ссылки, если оно ведёт на CRUD или TreeCRUD
					//
					$next=$this->checkCRUDByParent($punkt['id']);
					if($next===false){
						$s.=$punkt['punkt']['name'];
					}else{
						$link=$this->menuTree[$next]['module'];
						$s.="<a href='?view=$link'>".$punkt['punkt']['name']."</a>";
					}
					$s.="</div>
					<div>".$this->TreePaint($punkt['id'],$level+1)."</div>";
				}else{
					
				}
			}
			/*
			foreach($node as $i => $punkt){
				if($punkt['punkt']['type']=='menu'){
					if($max>0){
						?><li class='Node ExpandLeaf'><?php
					}else{
						?><li class='Node ExpandLeaf IsLast'><?php
					}
					$max--;
					?><div class='Expand'></div>
					<div class='Content' style='cursor:pointer;'>
					<?php
					//
					//меню должна показываться в виде ссылки, если оно ведёт на CRUD или TreeCRUD
					//
					$next=$this->checkCRUDByParent($punkt['id']);
					if($next===false){
						echo $punkt['punkt']['name'];
					}else{
						$link=$this->menuTree[$next]['module'];
						?><a href="?view=<?php echo $link;?>"><?php echo $punkt['punkt']['name'];?></a><?php
					}
					?>
					</div>
					<ul class='Container'><?php echo $this->TreePaint($punkt['id'],$level+1);?>
					</ul>
					</li><?php
				}else{
					
				}
			}
			*/
		}
		return $s;
	}
	function checkCRUDByParent($parent){
		//если находится CRUD или TreeCRUD, то вернуть id элемента, иначе вернуть false
		$result=false;
		foreach ($this->menuTree as $id => $element){
			if($element['parent']==$parent && ($element['type']=='CRUD' || $element['type']=='TreeCRUD')){
				$result=$id;
			}
		}
		return $result;
	}
	function getImgByType($type){
		switch($type){
			case 'menu':
				return 'menu.gif';
			break;
			case 'CRUD':
				return 'crud.gif';
			break;
			case 'TreeCRUD':
				return 'tree_crud.gif';
			break;
		}
	}
}
?>