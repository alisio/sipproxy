<?php
/*
 * Copyright (C) 2016-2017 OpenSIPS Project
 *
 * This file is part of opensips-cp, a free Web Control Panel Application for 
 * OpenSIPS SIP server.
 *
 * opensips-cp is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * opensips-cp is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

$id=$_GET['id'];
	
$sql = "select * from ".$table." where id='".$id."'";
$cl_form = $link->queryRow($sql);
$link->disconnect();
?>

<form action="<?=$page_name?>?action=modify&id=<?=$_GET['id']?>" method="post">
	<table width="400" cellspacing="2" cellpadding="2" border="0">
	
	<tr align="center">
		<td colspan="2" class="searchTitle">
			Edit Cluster Node
		</td>
	 </tr>

	<?php
	require("clusterer.form.php");
	?>

	<tr>
		<td colspan="2" class="dataRecord" align="center">
			<input type="submit" name="save" value="Save" class="formButton">
		</td>
	</tr>

	<tr height="10">
		<td colspan="2" class="dataTitle">
			<img src="../../../images/share/spacer.gif" width="5" height="5">
		</td>
	</tr>

	</table>
</form>
<?=$back_link?>

