<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%-- <c:set var="ctx" value="${pageContext.request.contextPath}"></c:set> --%>
<c:set var="ctx" value="/web"></c:set>
<c:set var="ctxscheme" value="${pageContext.request.scheme}"></c:set>
<c:set var="ctxserverName" value="${pageContext.request.serverName}"></c:set>
<c:set var="ctxserverPort" value="${pageContext.request.serverPort}"></c:set>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>


