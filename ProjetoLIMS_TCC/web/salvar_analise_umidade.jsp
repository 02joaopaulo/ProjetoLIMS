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
    <title>Salvar Análise de Umidade</title>
</head>
<body>
<%
String idAmostra = request.getParameter("idamostra");
String responsavelAnalise = request.getParameter("responsavelanalise");
double massarecipiente, massaumida, massaseca, umidade;
Timestamp dataHoraAnalise;

try {
    massarecipiente = Double.parseDouble(request.getParameter("massarecipiente"));
    massaumida = Double.parseDouble(request.getParameter("massaumida"));
    massaseca = Double.parseDouble(request.getParameter("massaseca"));

    // Calcular o PPC
    umidade = (1 - ((massaseca - massarecipiente) / massaumida)) * 100;

    // Obter a data/hora atual para o registro da análise
    dataHoraAnalise = Timestamp.valueOf(LocalDateTime.now());

    // Conectar ao banco de dados
    Class.forName("com.mysql.cj.jdbc.Driver");
    try (Connection conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");
         PreparedStatement st = conecta.prepareStatement("INSERT INTO analise_umidade (idamostra, massarecipiente, massaumida, massaseca, umidade, responsavelanalise, datahoraanalise) VALUES (?, ?, ?, ?, ?, ?, ?)")) {

        // Inserir os dados da análise de umidade no banco de dados
        st.setString(1, idAmostra);
        st.setDouble(2, massarecipiente);
        st.setDouble(3, massaumida);
        st.setDouble(4, massaseca);
        st.setDouble(5, umidade);
        st.setString(6, responsavelAnalise);
        st.setTimestamp(7, dataHoraAnalise);
        st.executeUpdate();
    }
    
    response.sendRedirect("liberacao.jsp");

} catch (NumberFormatException e) {
    out.print("Erro ao converter um dos valores de massa: " + e.getMessage());
    e.printStackTrace();
} catch (Exception e) {
    out.print("Erro na transmissão para o MySQL: " + e.getMessage());
    e.printStackTrace();
}
%>
</body>
</html>

