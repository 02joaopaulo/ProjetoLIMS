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

        // Obter a data e hora atual
        LocalDateTime dataHoraAtual = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String dataHoraAnalise = dataHoraAtual.format(formatter);

        Connection conecta = null;
        PreparedStatement st = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

            String sql = "INSERT INTO analise_raiox (idamostra, fe, sio2, al2o3, p, mn, responsavelanalise, datahoraanalise) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            st = conecta.prepareStatement(sql);
            st.setString(1, idAmostra);
            st.setString(2, fe);
            st.setString(3, sio2);
            st.setString(4, al2o3);
            st.setString(5, p);
            st.setString(6, mn);
            st.setString(7, responsavelAnalise);
            st.setString(8, dataHoraAnalise);

            st.executeUpdate();
            response.sendRedirect("consulta.jsp");
        } catch (ClassNotFoundException | SQLException e) {
            out.println("Erro ao salvar a análise de Raio-X: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (st != null) try { st.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conecta != null) try { conecta.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>