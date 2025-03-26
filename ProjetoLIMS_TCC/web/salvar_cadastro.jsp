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
// Ajuste para capturar o atributo correto
String usuarioLogado = (String) session.getAttribute("usuario"); 
LocalDateTime dataHoraLog = LocalDateTime.now();
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

try {
    nomeamostra = request.getParameter("nomeamostra");
    cliente = request.getParameter("cliente");
    analise = request.getParameter("analise");

    // Obter e converter a data/hora amostra
    String dataHoraStr = request.getParameter("datahoraamostra");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    LocalDateTime localDateTime = LocalDateTime.parse(dataHoraStr, dateFormatter);
    datahoraamostra = java.sql.Timestamp.valueOf(localDateTime);

    // Conectar ao banco de dados
    Connection conecta;
    PreparedStatement st;
    Class.forName("com.mysql.cj.jdbc.Driver");
    conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

    // Inserir os dados no banco de dados
    st = conecta.prepareStatement("INSERT INTO amostras (nomeamostra, datahoraamostra, cliente, analise) VALUES (?, ?, ?, ?)",
                                   PreparedStatement.RETURN_GENERATED_KEYS);
    st.setString(1, nomeamostra);
    st.setTimestamp(2, datahoraamostra);
    st.setString(3, cliente);
    st.setString(4, analise);
    st.executeUpdate();

    // Obter o ID gerado para a amostra
    java.sql.ResultSet generatedKeys = st.getGeneratedKeys();
    int idAmostra = 0;
    if (generatedKeys.next()) {
        idAmostra = generatedKeys.getInt(1);
    }

    // Fechar o PreparedStatement
    st.close();

    // Inserir registro no log
    PreparedStatement logSt = conecta.prepareStatement(
        "INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)");
    logSt.setString(1, "cadastro");
    logSt.setString(2, "Cadastro da amostra " + nomeamostra + " com o idamostra " + idAmostra);
    
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
    conecta.close();

    // Redirecionar para a página de consulta
    response.sendRedirect("consulta.jsp");

} catch (Exception e) {
    out.print("Erro na transmissão para o mySQL: " + e.getMessage());
    e.printStackTrace();
}
%>
</body>
</html>
