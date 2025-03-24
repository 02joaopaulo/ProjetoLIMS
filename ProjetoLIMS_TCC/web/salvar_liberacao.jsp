<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.time.LocalDateTime" %>
<%
    try {
        // Conectar ao banco de dados
        Connection conecta;
        PreparedStatement st;
        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

        // Obter ID da amostra e ação
        String idAmostra = request.getParameter("idamostra");
        String acao = request.getParameter("acao");
        
        // Atualizar a tabela relatorio_analises
        String updateSQL;
        if ("Liberar".equals(acao)) {
            updateSQL = "UPDATE relatorio_analises SET liberado = ?, datahoraliberacao = ? WHERE idamostra = ?";
            st = conecta.prepareStatement(updateSQL);
            st.setString(1, "sim");
            st.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
        } else {
            updateSQL = "UPDATE relatorio_analises SET liberado = ?, datahoraliberacao = ? WHERE idamostra = ?";
            st = conecta.prepareStatement(updateSQL);
            st.setString(1, null);
            st.setTimestamp(2, null);
        }
        st.setString(3, idAmostra);
        st.executeUpdate();

        // Fechar a conexão
        st.close();
        conecta.close();
        
        // Redirecionar de volta para a tela de liberação
        response.sendRedirect("liberacao.jsp");
    } catch (Exception e) {
        out.print("Erro ao atualizar a tabela: " + e.getMessage());
        e.printStackTrace();
    }
%>
