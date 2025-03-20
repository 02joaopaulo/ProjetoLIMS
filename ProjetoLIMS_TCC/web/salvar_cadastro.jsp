<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Cadastro</title>
</head>
<body>
<%
String nomeamostra, cliente, analise;
java.sql.Timestamp datahoraamostra;

try {
    nomeamostra = request.getParameter("nomeamostra");
    cliente = request.getParameter("cliente");
    analise = request.getParameter("analise");

    // Obter e converter a data/hora amostra
    String dataHoraStr = request.getParameter("datahoraamostra");
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    LocalDateTime localDateTime = LocalDateTime.parse(dataHoraStr, formatter);
    datahoraamostra = java.sql.Timestamp.valueOf(localDateTime);

    // Conectar ao banco de dados
    Connection conecta;
    PreparedStatement st;
    Class.forName("com.mysql.cj.jdbc.Driver");
    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

    // Inserir os dados no banco de dados
    st = conecta.prepareStatement("INSERT INTO amostras (nomeamostra, datahoraamostra, cliente, analise) VALUES (?, ?, ?, ?)");
    st.setString(1, nomeamostra);
    st.setTimestamp(2, datahoraamostra);
    st.setString(3, cliente);
    st.setString(4, analise);
    st.executeUpdate();

    response.sendRedirect("consulta.jsp");

    // Fechar a conexão
    st.close();
    conecta.close();
} catch (Exception e) {
    out.print("Erro na transmissão para o mySQL: " + e.getMessage());
    e.printStackTrace();
}
%>
</body>
</html>
