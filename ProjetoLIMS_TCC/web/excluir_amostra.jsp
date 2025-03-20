<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Excluir Amostra</title>
</head>
<body>
<%
String idAmostra = request.getParameter("idamostra");

try {
    // Conectar ao banco de dados
    Connection conecta;
    PreparedStatement st;
    Class.forName("com.mysql.cj.jdbc.Driver");
    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

    // Excluir a amostra do banco de dados
    st = conecta.prepareStatement("DELETE FROM amostras WHERE idamostra = ?");
    st.setInt(1, Integer.parseInt(idAmostra));
    st.executeUpdate();

    response.sendRedirect("consulta.jsp");

    // Fechar a conexão
    st.close();
    conecta.close();
} catch (Exception e) {
    out.print("Erro na exclusão da amostra: " + e.getMessage());
    e.printStackTrace();
}
%>
</body>
</html>
