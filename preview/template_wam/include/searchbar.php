<?
// Get the GET variables
$sitephoto = getvalescaped("form_sitephoto","");
$sitephoto_1 = getvalescaped("form_sitephoto_1","");
$sitephoto_2 = getvalescaped("form_sitephoto_2","");
$state = getvalescaped("form_state","");
$city = getvalescaped("form_city","");
$personnel=getvalescaped("form_personnel","");
$firstname = getvalescaped("form_firstname","");
$lastname = getvalescaped("form_lastname","");
$bunit = getvalescaped("form_businessunit","");
$dept = getvalescaped("form_department","");
$jobtitle = getvalescaped("form_jobtitle","");
// Set the form field to the previous values
$prevserviceval = array();
$prevserviceval["city"] = $city;
$prevserviceval["state"] = $state;
$prevserviceval["firstname"] = $firstname;
$prevserviceval["lastname"] = $lastname;
$prevserviceval["businessunit"] = $bunit;
$prevserviceval["department"] = $dept;
$prevserviceval["jobtitle"] = $jobtitle;

$brand_type = getvalescaped("brand_type", "");
$initiative_type = getvalescaped("initiative_type", "");
# pull values from cookies if necessary, for non-search pages where this info hasn't been submitted
if (!isset($restypes)) {$restypes=@$_COOKIE["restypes"];}
if (!isset($search) || ((strpos($search,"!")!==false))) {$quicksearch=@$_COOKIE["search"];} else {$quicksearch=$search;}

$setcountry="";
# Attempt to resolve a comma separated, country appended format back to the user's original quick search.
# This is purely a visual aid so the side bar stays the same rather than displaying the expanded query.
$count_special=0;# Keep track of how many other 'specials' we find
$keywords=split_keywords($quicksearch);
$simple=array();
$found_country="";$found_year="";$found_month="";$found_day="";
for ($n=0;$n<count($keywords);$n++)
	{
	if (trim($keywords[$n])!="")
		{
		if (strpos($keywords[$n],":")!==false) {$count_special++;} else {$simple[]=trim($keywords[$n]);}
		if (substr($keywords[$n],0,8)=="country:") {$count_special--;$found_country=substr($keywords[$n],8);}
		if (substr($keywords[$n],0,5)=="year:") {$count_special--;$found_year=substr($keywords[$n],5);}
		if (substr($keywords[$n],0,6)=="month:") {$count_special--;$found_month=substr($keywords[$n],6);}
		if (substr($keywords[$n],0,4)=="day:") {$count_special--;$found_day=substr($keywords[$n],4);}
		}
	}
if (($count_special==0) && (($found_country!="") || ($found_year!="") || ($found_month!="") || ($found_day!=""))) {$setcountry=$found_country;$quicksearch=join(" ",trim_array($simple));}

?>

<style type="text/css">
#rightSearchPanel {
	border-top: 1px solid #94A7C0;
}

.rightSearchPanelFormBox {
	background-color: #6883A8 !important ;
	border: thin solid #94A7C0;
	margin-top: 5px;
	margin: 3px;
}

.rightSearchPanelFormBox .SearchWidth {
	width: 90% !important;
}

</style>
<div id="SearchBox">
<div id="SearchBoxPanel">
<? if(checkperm("e-0")) { ?>
<div id="SearchBoxPanel" align="left" style="padding-top:5px;padding-bottom:5px;"><a target="main" href="<?=$baseurl?>/team_resource.php">&nbsp;&nbsp;&raquo;&nbsp;<?=$lang["managemyresources"]?></a></div>
<? } ?>

<? hook("searchbartoptoolbar"); ?>

<div class="SearchSpace">

<? if (!hook("searchbarreplace")) { ?>

  <h2><?=$lang["simplesearch"]?></h2>
	<p><?=text("searchpanel")?></p>
	
	<form id="form1" method="get" action="<?=$baseurl?>/search.php">

        <input id="ssearchbox" name="search" type="text" class="SearchWidth" value="<?=htmlspecialchars(stripslashes(@$quicksearch))?>">

<input type=hidden name="resetrestypes" value="yes">
<?
$rt=explode(",",@$restypes);
$function="";

$defaultcheck = false;
if(getval("first_run", "")=="yes") $defaultcheck = true;

$types=get_resource_types();for ($n=0;$n<count($types);$n++)
	{
		?><div class="tick"><input id="TickBox<?=$n?>" type=checkbox onclick="javascript:toggleTab('TickBox<?=$n?>');" name="resource<?=$types[$n]["ref"]?>" value="yes" <? if ((((((count($rt)==1) && ($rt[0]==""))) || (in_array($types[$n]["ref"],$rt))) && !$defaultcheck) || (($types[$n]["name"]=="Site Photo: Exterior" || $types[$n]["name"]=="Site Photo: Interior") && $defaultcheck)) {?>checked<?}?>>&nbsp;
		<? if($types[$n]["name"]=="Brand Logo or Design Element") { ?><div style="font-size: 10px; display: inline;">Brand Logo/Design Element</div><? } else { ?>
		<?=$types[$n]["name"]?>
		<? } ?>
		
		</div><?	
		$function.="document.getElementById('TickBox" . $n . "').checked=true;";
		
			if($types[$n]["name"]=="Site Photo: Exterior") {
			?>
			<div class="rightSearchPanelFormBox" id="rightPanelBox1" style="color: white; text-align: left; display: none;"><b>Site Photo: </b>
			<div style="margin: 5px;">
			<b>City</b><input id="city" name="city" type="text" class="SearchWidth" value="<? if(isset($prevserviceval["city"])) echo $prevserviceval["city"]; ?>" />
			<br/>
			<b>State</b><input id="state" name="state" type="text" class="SearchWidth" value="<? if(isset($prevserviceval["state"])) echo $prevserviceval["state"]; ?>" />
			</div>
			</div>
			<?
			}
				
			if($types[$n]["name"]=="Personnel Photo") {
			?>
			<div class="rightSearchPanelFormBox" id="rightPanelBox2" style="color: white; text-align: left; display: none;">
			<b>Personnel Photo: </b>
				<div style="margin: 5px;">
					<b>First Name</b><input id="firstname" name="firstname" type="text" class="SearchWidth" value="<? if(isset($prevserviceval["firstname"])) echo $prevserviceval["firstname"]; ?>" />
					<br/>
					<b>Last Name</b><input id="lastname" name="lastname" type="text" class="SearchWidth" value="<? if(isset($prevserviceval["lastname"])) echo $prevserviceval["lastname"]; ?>" />
					<br/>
					<b>Business Unit</b><input id="businessunit" name="businessunit" type="text" class="SearchWidth" value="<? if(isset($prevserviceval["businessunit"])) echo $prevserviceval["businessunit"]; ?>" />
					<br/>
					<b>Department</b><input id="department" name="department" type="text" class="SearchWidth" value="<? if(isset($prevserviceval["department"])) echo $prevserviceval["department"]; ?>" />
					<br/>
					<b>Job Title</b><input id="jobtitle" name="jobtitle" type="text" class="SearchWidth" value="<? if(isset($prevserviceval["jobtitle"])) echo $prevserviceval["jobtitle"]; ?>" />
				</div>
			</div>
			<?
			}
		
		}
?>
<input name="Submit" type="button" value="&nbsp;&nbsp;<?=$lang["searchbutton"]?>&nbsp;&nbsp;" onclick="javascript:submitSearchForm();" />
<script type="text/javascript">
function setTabSideBar() {
	if("<?=$username?>"!="Service") return;
	check_boxes = [<?
	$types=get_resource_types();for ($n=0;$n<count($types);$n++)
	{
		echo '"'.'TickBox'.$n.'"';
		if((count($types)-$n)!=1) echo ',';
	}?>];
	
	for(var i=0;i<check_boxes.length;i++) {
		if(check_boxes[i]=="TickBox0" ||  check_boxes[i]=="TickBox1" || check_boxes[i]=="TickBox4") {
			if(document.getElementById(check_boxes[i]).checked) {
				document.getElementById(check_boxes[i]).parentNode.style.background = "#4D6B94";
				document.getElementById(check_boxes[i]).parentNode.style.width = "166px";
				document.getElementById(check_boxes[i]).parentNode.style.border = "thin solid #94A7C0";
				document.getElementById(check_boxes[i]).parentNode.style.marginTop = "5px";
				document.getElementById(check_boxes[i]).parentNode.style.borderRight = "none";
				if(document.getElementById('TickBox0').checked || document.getElementById('TickBox1').checked) {
					document.getElementById("rightPanelBox1").style.display = "block";
				} else {
					document.getElementById("rightPanelBox2").style.display = "none";
				}
				if(!document.getElementById('TickBox4').checked) {
					document.getElementById("rightPanelBox2").style.display = "none";
				} else {
					document.getElementById("rightPanelBox2").style.display = "block";
				}
			}
		}
	}
}



function toggleTab(check_box) {
		if("<?=$username?>"!="Service") return;
		if(check_box=="TickBox0" ||  check_box=="TickBox1" || check_box=="TickBox4") {
	
		
			if(document.getElementById(check_box).checked) {
				document.getElementById("rightSearchPanel").style.display = "block";
				document.getElementById(check_box).parentNode.style.background = "#4D6B94";
				document.getElementById(check_box).parentNode.style.width = "166px";
				document.getElementById(check_box).parentNode.style.border = "thin solid #94A7C0";
				document.getElementById(check_box).parentNode.style.marginTop = "5px";
				document.getElementById(check_box).parentNode.style.borderRight = "none";
				if(check_box=="TickBox0" ||  check_box=="TickBox1") {
					document.getElementById("rightPanelBox1").style.display = "block";
				}
				if(check_box=="TickBox4") {
					document.getElementById("rightPanelBox2").style.display = "block";
				}
			} else {
				if(!(document.getElementById('TickBox0').checked || document.getElementById('TickBox1').checked || document.getElementById('TickBox4').checked)) {
					document.getElementById("rightSearchPanel").style.display = "none";
				}
				if(check_box=="TickBox0" || check_box=="TickBox1") {
					if(!(document.getElementById('TickBox0').checked || document.getElementById('TickBox1').checked)) {
						document.getElementById("rightPanelBox1").style.display = "none";
					}
				}
				if(check_box=="TickBox4") {
					document.getElementById("rightPanelBox2").style.display = "none";
				}
				
				document.getElementById(check_box).parentNode.style.background = "none";
				document.getElementById(check_box).parentNode.style.width = "166px";
				document.getElementById(check_box).parentNode.style.border = "none";
				document.getElementById(check_box).parentNode.style.marginTop = "none";
			}
		}
}

// for Internet Explorer (using conditional comments)
/*@cc_on @*/
/*@if (@_win32)
document.write("<script id=__ie_onload defer src=javascript:void(0)><\/script>");
var script = document.getElementById("__ie_onload");
script.onreadystatechange = function() {
  if (this.readyState == "complete") {
    setTabSideBar(); // call the onload handler
  }
};
/*@end @*/


</script>

<script language="Javascript">
function ResetTicks() {<?=$function?>}
</script>

				<? if ($country_search) { ?>
				<div class="SearchItem"><?=$lang["bycountry"]?><br />
				<?
				$options=get_field_options(3);
				?>
				<select id="basiccountry" name="country" class="SearchWidth">
				  <option selected="selected" value=""><?=$lang["anycountry"]?></option>
				  <?
				  for ($n=0;$n<count($options);$n++)
				  	{
				  	$c=i18n_get_translated($options[$n]);
				  	?><option <? if (strtolower(str_replace(".","",$c))==$setcountry) { ?>selected<? } ?>><?=$c?></option><?
				  	}
				  ?>

				</select>
				</div>
				<? } ?>
		
				
				<? 
				// Allow the user to specify a brand in the search if they are not a property site user
				$user_can_brand = sql_query("select username from user where ref='$userref' AND username IN (SELECT site_number FROM wyndham_properties)");
				if(!isset($user_can_brand[0])) { ?>
				<div class="SearchItem"><?=$lang["bybrand"]?><br />
				<select id="brand_type" name="brand_type" class="SearchWidth" style="width:100px;">
				  <?
				  $brand_selected = false;
				  $brands=sql_query("SELECT distinct value FROM resource_data WHERE resource_type_field = 63");
					if($brands) {
						for ($n=0;$n<count($brands);$n++)
						{
							if($brands[$n]["value"]!="") {
							?><option value="<?=$brands[$n]["value"]?>" <? 
							
							
							if(isset($brand_type)) {
								if($brand_type==$brands[$n]["value"]) {
									$brand_selected = true;
									?>selected<?
							
								}
							}
							
							?>><?=$brands[$n]["value"]?></option><?
							}
						}
					}?>
				  <option <? if(!$brand_selected) { ?>selected<? } ?> value="anybrand"><?=$lang["anybrand"]?></option>
				</select>
				</div>
				<? } ?>
				
				
				
				<div class="SearchItem"><?=$lang["byinitiative"]?><br />
				<select id="initiative_type" name="initiative_type" class="SearchWidth" style="width:100px;">
				  <?
				  // Allow the user to specify an initiative in the search
				  $init_selected = false;
				  $initiatives=sql_query("SELECT distinct value FROM resource_data WHERE resource_type_field = 69");
					if($initiatives) {
						for ($n=0;$n<count($initiatives);$n++)
						{
							if($initiatives[$n]["value"]!="") {
							?><option value="<?=$initiatives[$n]["value"]?>" <? 
							
							
							if(isset($initiative_type)) {
								if($initiative_type==$initiatives[$n]["value"]) {
									$init_selected = true;
									?>selected<?
							
								}
							}
							
							?>><?=$initiatives[$n]["value"]?></option><?
							}
						}
					}?>
				  <option <? if(!$init_selected) { ?>selected<? } ?> value="anyinitiative"><?=$lang["anyinitiative"]?></option>
				  
				</select>
				</div>
								<div class="SearchItem"><?=$lang["bydate"]?><br />
				<select id="basicyear" name="year" class="SearchWidth" style="width:70px;">
				  <option selected="selected" value=""><?=$lang["anyyear"]?></option>
				  <?
				  $y=date("Y");
				  for ($n=$y;$n>=$minyear;$n--)
				  	{
				  	?><option <? if ($n==$found_year) { ?>selected<? } ?>><?=$n?></option><?
				  	}
				  ?>
				</select>


				<? if ($searchbyday) { ?><br /><? } ?>

				<select id="basicmonth" name="month" class="SearchWidth" style="width:80px;">
				  <option selected="selected" value=""><?=$lang["anymonth"]?></option>
				  <?
				  for ($n=1;$n<=12;$n++)
				  	{
				  	$m=str_pad($n,2,"0",STR_PAD_LEFT);
				  	?><option <? if ($n==$found_month) { ?>selected<? } ?> value="<?=$m?>"><?=$lang["months"][$n-1]?></option><?
				  	}
				  ?>

				</select>

				<? if ($searchbyday) { ?>
				<select id="basicday" name="day" class="SearchWidth" style="width:70px;">
				  <option selected="selected" value=""><?=$lang["anyday"]?></option>
				  <?
				  for ($n=1;$n<=31;$n++)
				  	{
				  	$m=str_pad($n,2,"0",STR_PAD_LEFT);
				  	?><option <? if ($n==$found_day) { ?>selected<? } ?> value="<?=$m?>"><?=$m?></option><?
				  	}
				  ?>
				</select>
				<? } ?>

				</div>
				
				
				
				<? /* <!--				
				<div class="SearchItem">By Category<br />
				<select name="Country" class="SearchWidth">
				  <option selected="selected">All</option>
				  <option>Places</option>
					<option>People</option>
				  <option>Places</option>
					<option>People</option>
				  <option>Places</option>
				</select>
				</div>
				--> */ ?>
						        <div class="SearchItem"><input name="Submit" type="button" value="&nbsp;&nbsp;<?=$lang["searchbutton"]?>&nbsp;&nbsp;" onclick="javascript:submitSearchForm();" /><? /*<input name="Clear" type="button" value="&nbsp;&nbsp;<?=$lang["clearbutton"]?>&nbsp;&nbsp;" onClick="document.getElementById('ssearchbox').value='';
		        <? if ($country_search==true) {?>document.getElementById('basiccountry').value='';
		        <? } ?>
		        document.getElementById('basicyear').value='';document.getElementById('basicmonth').value='';document.getElementById('basicday').value='';ResetTicks();"/> */ ?>
		        
		        <? 
		        if(is_numeric($username) || $username!="Service") { ?>
		      	  <input type="hidden" name="form_issiteuser" id="form_issiteuser" value="yes" />
		        <? } else { ?>
		          <input type="hidden" name="form_issiteuser" id="form_issiteuser" value="no" />
		        <? } ?>
		        <input type="hidden" name="form_sitephoto" id="form_sitephoto" value="" />
		        <input type="hidden" name="form_sitephoto_1" id="form_sitephoto_1" value="" />
		        <input type="hidden" name="form_sitephoto_2" id="form_sitephoto_2" value="" />
		        <input type="hidden" name="form_personnel" id="form_personnel" value="" />
		        
		        <input type="hidden" name="form_city" id="form_city" value="" />
		        <input type="hidden" name="form_state" id="form_state" value="" />
		        <input type="hidden" name="form_firstname" id="form_firstname" value="" />
		        <input type="hidden" name="form_lastname" id="form_lastname" value="" />
		        <input type="hidden" name="form_businessunit" id="form_businessunit" value="" />
		        <input type="hidden" name="form_department" id="form_department" value="" />
		        <input type="hidden" name="form_jobtitle" id="form_jobtitle" value="" />
		        <input type="hidden" name="form_brand" id="form_brand" value="" />
		        <input type="hidden" name="form_init" id="form_init" value="" />
		        
		        
		        
<script type="text/javascript">
function submitSearchForm() {
<? 
		        if(is_numeric($username)) { ?>
		        
		        document.getElementById('form1').submit();
		        
		        
		        <? } ?>
	check_boxes = [<?
	$types=get_resource_types();for ($n=0;$n<count($types);$n++)
	{
		echo '"'.'TickBox'.$n.'"';
		if((count($types)-$n)!=1) echo ',';
	}?>];

	if(document.getElementById('TickBox0').checked || document.getElementById('TickBox1').checked) {
		document.getElementById('form_sitephoto').value = "yes";
		
		if(document.getElementById('TickBox0').checked) document.getElementById('form_sitephoto_1').value = "yes";
		else document.getElementById('form_sitephoto_1').value = "no";
		
		if(document.getElementById('TickBox1').checked) document.getElementById('form_sitephoto_2').value = "yes";
		else document.getElementById('form_sitephoto_2').value = "no";
		
		document.getElementById('form_city').value  = document.getElementById('city').value;
		document.getElementById('form_state').value = document.getElementById('state').value;
	} else {
		document.getElementById('form_sitephoto').value = "no";
		document.getElementById('form_sitephoto_1').value = "no";
		document.getElementById('form_sitephoto_2').value = "no";
		document.getElementById('form_city').value  = "";
		document.getElementById('form_state').value = "";
	}

	if(document.getElementById('TickBox4').checked) {
		document.getElementById('form_personnel').value = "yes";
		document.getElementById('form_firstname').value	   = document.getElementById('firstname').value;
		document.getElementById('form_lastname').value	   = document.getElementById('lastname').value;
		document.getElementById('form_businessunit').value = document.getElementById('businessunit').value;
		document.getElementById('form_department').value   = document.getElementById('department').value;
		document.getElementById('form_jobtitle').value	   = document.getElementById('jobtitle').value;
	} else {
		document.getElementById('form_personnel').value = "no";
		document.getElementById('form_firstname').value	   = "";
		document.getElementById('form_lastname').value	   = "";
		document.getElementById('form_businessunit').value = "";
		document.getElementById('form_department').value   = "";
		document.getElementById('form_jobtitle').value	   = "";
	}
	document.getElementById('form1').submit();
}
</script>
		    
		    
		      
		       
		       </div>
				<div class="SearchItem"><?=$lang["resultsdisplay"]?><br />
				<select name="per_page" class="SearchWidth">
				  <option value="12" <? if (getval("per_page",$default_perpage)==12) { ?>selected<? } ?> >12 <?=$lang["perpage"]?></option>
				  <option value="24" <? if (getval("per_page",$default_perpage)==24) { ?>selected<? } ?> >24 <?=$lang["perpage"]?></option>
				  <option value="48" <? if (getval("per_page",$default_perpage)==48) { ?>selected<? } ?> >48 <?=$lang["perpage"]?></option>
				  <option value="72" <? if (getval("per_page",$default_perpage)==72) { ?>selected<? } ?> >72 <?=$lang["perpage"]?></option>
				</select>
				</div>
	
				  <div class="tick"><label><input name="display" type="radio" value="thumbs" <? if (getval("display","thumbs")=="thumbs") { ?>checked="checked"<? } ?> />&nbsp;<?=$lang["largethumbs"]?></label>
				  <? if ($smallthumbs==true){?><label><input name="display" type="radio" value="smallthumbs" <? if (getval("display","smallthumbs")=="smallthumbs") { ?>checked="checked"<? } ?> />&nbsp;<?=$lang["smallthumbs"]?></label><?}?>
				  </div>
				  <div class="tick"><label><input type="radio" name="display" value="list" <? if (getval("display","")=="list") { ?>checked="checked"<? } ?> />&nbsp;<?=$lang["list"]?></label></div>
				  <div class="tick"><label><input type="radio" name="display" value="thumblist" <? if (getval("display","")=="thumblist" || getval("display","")=="") { ?>checked="checked"<? } ?> />&nbsp;<?=$lang["thumblist"]?></label></div>
				  <div class="tick"><label><input type="radio" name="display" value="detail" <? if (getval("display","")=="detail") { ?>checked="checked"<? } ?> />&nbsp;<?=$lang["detail"]?></label></div>
			
	
  <p><br /><a href="<?=$baseurl?>/search_advanced.php">&gt; <?=$lang["gotoadvancedsearch"]?></a></p>
  <p><a href="<?=$baseurl?>/search.php?search=<?=urlencode("!last1000")?>&form_issiteuser=yes">&gt; <?=$lang["viewnewmaterial"]?></a></p>
	</div>
	  </form>
	<? } ?> <!-- END of Searchbarreplace hook --><div id="rightSearchPanel" style="display: none;"></div>
<!-- end s -->
	</div>
	
	<div class="PanelShadow"></div>
	
	
	<? if (($research_request) && (checkperm("q"))) { ?>
	<div id="ResearchBoxPanel">
  <div class="SearchSpace">
  <h2><?=$lang["researchrequest"]?></h2>
	<p><?=text("researchrequest")?></p>
	<div class="HorizontalWhiteNav"><a href="<?=$baseurl?>/research_request.php">&gt; <?=$lang["researchrequestservice"]?></a></div>
	</div><br />

	</div>
	<div class="PanelShadow"></div>
	<? } ?>
<? hook("searchbarbottomtoolbar"); ?>
</div>





