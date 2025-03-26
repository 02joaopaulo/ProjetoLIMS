<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Salvar Análise de Raio-X</title>
</head>
<body>
<%
String idAmostra = request.getParameter("idamostra");
String fe = request.getParameter("fe");
String sio2 = request.getParameter("sio2");
String al2o3 = request.getParameter("al2o3");
String p = request.getParameter("p");
String mn = request.getParameter("mn");
String responsavelAnalise = request.getParameter("responsavelanalise");
LocalDateTime dataHoraAtual = LocalDateTime.now();
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
String dataHoraAnalise = dataHoraAtual.format(formatter);

// Capturando o usuário logado
String usuarioLogado = (String) session.getAttribute("usuario");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

    // Inserir os dados da análise de Raio-X
    try (PreparedStatement st = conecta.prepareStatement(
         "INSERT INTO analise_raiox (idamostra, fe, sio2, al2o3, p, mn, responsavelanalise, datahoraanalise) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {
        st.setString(1, idAmostra);
        st.setString(2, fe);
        st.setString(3, sio2);
        st.setString(4, al2o3);
        st.setString(5, p);
        st.setString(6, mn);
        st.setString(7, responsavelAnalise);
        st.setString(8, dataHoraAnalise);
        st.executeUpdate();
    }

    // Registrar log
    try (PreparedStatement logSt = conecta.prepareStatement(
         "INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)")) {
        logSt.setString(1, "analise_raiox");
        logSt.setString(2, "Análise de Raio-X registrada para amostra " + idAmostra);
        if (usuarioLogado != null && !usuarioLogado.isEmpty()) {
            logSt.setString(3, usuarioLogado);
        } else {
            logSt.setString(3, "Usuário desconhecido");
        }
        logSt.setString(4, dataHoraAtual.format(formatter));
        logSt.executeUpdate();
    }

    conecta.close();
    response.sendRedirect("consulta.jsp");

} catch (ClassNotFoundException | SQLException e) {
    out.println("Erro ao salvar a análise de Raio-X: " + e.getMessage());
    e.printStackTrace();
}
%>
</body>
</html>
