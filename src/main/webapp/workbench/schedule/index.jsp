<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>


	<script type="text/javascript">

	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$("#editBtn").click(function (){
			let $xz = $("input[name=xz]:checked");
			if($xz.length == 0){
				alert("请选择你需要修改的线索");
			}else if ($xz.length != 1){
				alert("仅能修改1一条线索")
			}else{
				$("#hidden-id").val($xz.val());

				$.ajax({
					url:"workbench/schedule/getUserListAndschedule.do",
					data:{
						id:$xz.val()
					},
					type:"get",
					dataType:"json",
					success:function(result){
						/*
							result:
								result:{"user":{"name":"张三","id":"324532bsddfg",...},
									"userList":["zhangsan":{},"lisi":{},...],"schedule":{"id":"","mphoe","",...}],
									"contact":{"id":"asdfasasdf235423","mainClass":"张三",...}
								}
						 */
						let html = "<option selected='selected' value='"+result.user.id+"'>" + result.user.name + "</option>"
						$.each(result.userList,function (i,n){
							html += "<option value='"+n.id+"'>" + n.name + "</option>"
						})

						$("#edit-mainClass").html(html);

						let schedule = result.schedule;
						$("#edit-doctor").val(schedule.doctor)
						$("#edit-appellation").val(schedule.appellation)
						$("#edit-mainClass").val(schedule.mainClass)
						$("#edit-job").val(schedule.job)
						$("#edit-email").val(schedule.email)
						$("#edit-mphone").val(schedule.mphone)
                        $("#edit-date").val(schedule.date)
						$("#edit-source").val(schedule.source)
                        $("#edit-techRoom").val(schedule.customerId)
						$("#edit-description").val(schedule.description)
						$("#edit-scheduleummary").val(schedule.scheduleummary)
						$("#edit-nextContactTime").val(schedule.nextContactTime)
						$("#edit-address").val(schedule.address)
						$("#editScheduleModal").modal("show");
					}
				})
			}
		})

		$("#updateBtn").click(function (){
			let id = $("#hidden-id").val();
			$.ajax({
				url:"workbench/schedule/update.do",
				data:{
					"id":id,
					"doctor":$.trim($("#edit-doctor").val()),
					"appellation":$.trim($("#edit-appellation").val()),
					"mainClass":$.trim($("#edit-mainClass").val()),
					"job":$.trim($("#edit-job").val()),
					"email":$.trim($("#edit-email").val()),
					"source":$.trim($("#edit-source").val()),
					"description":$.trim($("#edit-description").val()),
					"techRoom":$.trim($("#edit-techRoom").val()),
					"scheduleummary":$.trim($("#edit-scheduleummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address").val()),
					"mphone":$.trim($("#edit-mphone").val()),
					"date":$.trim($("#edit-date").val())
				},
				type:"post",
				dataType:"json",
				success:function(result){
					if(result){
						pageList($("#schedulePage").bs_pagination('getOption','currentPage'),
								$("#schedulePage").bs_pagination('getOption','rowsPerPage'));
						$("#editScheduleModal").modal("hide");
					}else{
						alert("更新失败!");
					}
				}
			})
		})

		$("#create-techRoom").typeahead({
			source: function (query, process) {
				$.get(
						"workbench/transaction/gettechRoom.do",
						{ "name" : query },
						function (data) {
							//alert(data);
							process(data);
						},
						"json"
				);
			},
			delay: 100
		});
		$("#edit-techRoom").typeahead({
			source: function (query, process) {
				$.get(
						"workbench/transaction/gettechRoom.do",
						{ "name" : query },
						function (data) {
							//alert(data);
							process(data);
						},
						"json"
				);
			},
			delay: 100
		});

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		$("#searchBtn").click(function (){
			$("#hide-mainClass").val($.trim($("#search-mainClass").val()));
			$("#hide-doctor").val($.trim($("#search-doctor").val()));
			$("#hide-techRoom").val($.trim($("#search-techRoom").val()));

			pageList($("#schedulePage").bs_pagination('getOption','currentPage'),
					$("#schedulePage").bs_pagination('getOption','rowsPerPage'));
		})
		$("#selectAll").click(function(){
			$("input[name=xz]").prop("checked",this.checked)
		})
		$("#scheduleBody").on("click",$("input[name=xz]"),function (){
			$("#selectAll").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		pageList(1,10);

		$("#saveBtn").click(function (){
			$.ajax({
				url:"workbench/schedule/save.do",
				data:{
					"doctor":$.trim($("#create-doctor").val()),
					"appellation":$.trim($("#create-appellation").val()),
					"mainClass":$.trim($("#create-mainClass").val()),
					"job":$.trim($("#create-job").val()),
					"techRoom":$.trim($("#create-techRoom").val()),
					"email":$.trim($("#create-email").val()),
					"mphone":$.trim($("#create-mphone").val()),
					"source":$.trim($("#create-subentry").val()),
					"description":$.trim($("#create-description").val()),
					"scheduleummary":$.trim($("#create-scheduleummary").val()),
					"nextContactTime":$.trim($("#create-nextContactTime").val()),
					"date":$.trim($("#create-date").val()),
					"address":$.trim($("#create-address").val())
				},
				type:"post",
				dataType:"json",
				success:function(result){
					/*
						data
							{"success",true/false}
					 */
					if(result){

						// 刷新列表
						pageList(1,
								$("#schedulePage").bs_pagination('getOption','rowsPerPage'))
						// 刷新保存中的数据
						$("#scheduleForm")[0].reset();

						// 关闭模态窗口
						$("#createscheduleModal").modal("hide");
					}else{
						alert("添加线索失败")
					}
				}
			})
		})

		$("#deleteBtn").click(function(){
			let $xz = $("input[name=xz]:checked");

			if($xz.length == 0){
				alert("请选择需要删除的线索")
			}else{
				if(confirm("确认要删除以下"+$xz.length+"条线索吗")){
					let param ="";
					$.each($xz,function(i,n){
						param += "id=" + n.value;
						// 如果不是最后一个元素，需要在后面追减一个&
						if(i < $xz.length - 1){
							param+="&";
						}
					})

					// alert(param);
					$.ajax({
						url:"workbench/schedule/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function(result){
							if(result){
								pageList($("#schedulePage").bs_pagination('getOption','currentPage'),
										$("#schedulePage").bs_pagination('getOption','rowsPerPage'));
							}else{
								alert("删除失败");
							}
						}
					})

				}
			}
		})

		$("#createBtn").click(function(){
			$.ajax({
				url:"workbench/schedule/getUserList.do",
				type:"get",
				dataType:"json",
				success:function(data){
					let html = "";
					$.each(data,function(i,n){
						html += "<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#create-mainClass").html(html);

					let id = "${user.id}";
					$("#create-mainClass").val(id);

					// 处理完下拉框数据后，打开模态窗口
					$("#createscheduleModal").modal("show");
				}
			})
		})
	});

	function pageList(pageNo,pageSize){

		$("#selectAll").prop("checked",false);

		$("#search-mainClass").val($.trim($("#hide-mainClass").val()));
		$("#search-doctor").val($.trim($("#hide-doctor").val()));
		$("#search-techRoom").val($.trim($("#hide-techRoom").val()));

		$.ajax({
			url:"workbench/schedule/pageList.do",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"mainClass":$("#search-mainClass").val(),
				"doctor":$("#search-doctor").val(),
				"techRoom":$("#search-techRoom").val(),
			},
			type:"get",
			dataType:"json",
			success:function(data){
				/*
					result:
					{"total":100,"scheduleList":["线索1":{"id":adsfa,...},"线索2":{"":..}]}
					 result.
				 */
				let html = "";
				$.each(data.dataList,function(i,n){
					html += '<tr class="active">'
					html += '	<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
					html += '	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/schedule/detail.do?id='+n.id+'\';">'+n.doctorName+'</a></td>'
					html += '	<td>'+n.docGrade+'</td>'
					html += '	<td>'+n.techOfficeName+'</td>'
					html += '	<td>'+n.dutyType+'</td>'
					html += '   <td>'+n.dutyDate+'</td>'
					html += '	<td>'+n.dutyTimeStage+'</td>'
					html += '</tr>'
				})

				$("#scheduleBody").html(html);

				let totalPages = data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1

				$("#schedulePage").bs_pagination({
					currentPage: pageNo,
					rowsPerPage: pageSize,
					maxRowsPerPage: 20,
					totalPages: totalPages,
					totalRows: data.total,
					visiblePageLinks: 3,

					showGoToPage:true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					// 该回掉函数在，点击分页组件的时候触发的
					onChangePage : function(event, result){
						pageList(result.currentPage , result.rowsPerPage);
					}
				});
			}
		})
	}
	
</script>
</head>
<body>
<input type="hidden" id="hide-mainClass">
<input type="hidden" id="hide-doctor">
<input type="hidden" id="hide-techRoom">

	<!-- 创建排班的模态窗口 -->
	<div class="modal fade" id="createscheduleModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createscheduleModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建排班</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="scheduleForm" role="form">
					
						<div class="form-group">
							<label for="create-mainClass" class="col-sm-2 control-label">大项名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-mainClass">
								</select>
							</div>
							<label for="create-subentry" class="col-sm-2 control-label">分项名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-subentry">
								  <option></option>
									<c:forEach items="${source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-doctor" class="col-sm-2 control-label">医生姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-doctor">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-date" class="col-sm-2 control-label">值班日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-date">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-techRoom" class="col-sm-2 control-label">诊室名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-techRoom" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-scheduleummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-scheduleummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改排班的模态窗口 -->
    <input type="hidden" id="hidden-id">
	<div class="modal fade" id="editScheduleModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改排班</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-mainClass" class="col-sm-2 control-label">大项名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-mainClass">
								</select>
							</div>
							<label for="edit-source" class="col-sm-2 control-label">分项名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
                                    <c:forEach items="${source}" var="s">
                                        <option value="${s.value}">${s.text}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-doctor" class="col-sm-2 control-label">医生姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-doctor" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
                                    <c:forEach items="${appellation}" var="a">
                                        <option value="${a.value}">${a.text}</option>
                                    </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-date" class="col-sm-2 control-label">值班日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-date">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-techRoom" class="col-sm-2 control-label">诊室名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-techRoom" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-scheduleummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-scheduleummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>排班列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">大项名称</div>
						<input class="form-control" id="search-mainClass" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">医生姓名</div>
						  <input class="form-control" id="search-doctor" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">诊室名称</div>
						<input class="form-control" id="search-techRoom" type="text">
				    </div>
					  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  </div>
				  <br>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" id="createBtn" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editBtn" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll"/></td>
							<td>医生姓名</td>
							<td>医生级别</td>
							<td>医生房间</td>
							<td>值班类型</td>
							<td>值班日期</td>
							<td>值班时段</td>
						</tr>
					</thead>
					<tbody id="scheduleBody">
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">
				<div id="schedulePage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>