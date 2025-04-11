<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.time.LocalDateTime" %>
<%
    try {
        // Conectar ao banco de dados
        Connection conecta;
        PreparedStatement st, logSt;
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

        // Registrar log da ação na tabela logs
        String usuarioLogado = (String) session.getAttribute("usuario"); // Capturar o usuário logado
        String logSQL = "INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)";
        logSt = conecta.prepareStatement(logSQL);
        logSt.setString(1, "Liberação");
        logSt.setString(2, "Realizado o " + acao + " para amostra de ID " + idAmostra);
        if (usuarioLogado != null && !usuarioLogado.isEmpty()) {
            logSt.setString(3, usuarioLogado);
        } else {
            logSt.setString(3, "Usuário desconhecido");
        }
        logSt.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
        logSt.executeUpdate();

        // Fechar as conexões
        st.close();
        logSt.close();
        conecta.close();

        // Redirecionar de volta para a tela de liberação
        response.sendRedirect("liberacao.jsp");
    } catch (Exception e) {
        out.print("Erro ao atualizar a tabela: " + e.getMessage());
        e.printStackTrace();
    }
%>
