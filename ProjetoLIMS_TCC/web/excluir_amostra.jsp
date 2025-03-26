<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Excluir Amostra</title>
</head>
<body>
<%
String idAmostra = request.getParameter("idamostra");
// Capturando o usuário logado da sessão
String usuarioLogado = (String) session.getAttribute("usuario"); 
LocalDateTime dataHoraLog = LocalDateTime.now();
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

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

    // Inserir registro no log
    PreparedStatement logSt = conecta.prepareStatement(
        "INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)");
    logSt.setString(1, "Consulta");
    logSt.setString(2, "Exclusão da amostra com idamostra: " + idAmostra);
    
    // Verificando se o usuário logado não está nulo
    if (usuarioLogado != null && !usuarioLogado.isEmpty()) {
        logSt.setString(3, usuarioLogado);
    } else {
        logSt.setString(3, "Usuário desconhecido");
    }
    
    logSt.setString(4, dataHoraLog.format(formatter));
    logSt.executeUpdate();

    // Fechar o PreparedStatement e a conexão
    logSt.close();
    st.close();
    conecta.close();

    response.sendRedirect("consulta.jsp");

} catch (Exception e) {
    out.print("Erro na exclusão da amostra: " + e.getMessage());
    e.printStackTrace();
}
%>
</body>
</html>
