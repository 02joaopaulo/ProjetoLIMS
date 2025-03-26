<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%
    String idusuario = request.getParameter("idusuario");
    String usuario = "";

    try {
        // Conectar ao banco de dados
        Connection conecta;
        PreparedStatement st;
        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

        // Obter o nome do usuário antes de excluí-lo
        PreparedStatement stUsuario = conecta.prepareStatement("SELECT usuario FROM usuario WHERE idusuario = ?");
        stUsuario.setString(1, idusuario);
        ResultSet rsUsuario = stUsuario.executeQuery();
        if (rsUsuario.next()) {
            usuario = rsUsuario.getString("usuario"); // Captura o nome do usuário
        }
        rsUsuario.close();
        stUsuario.close();

        // Excluir o usuário
        st = conecta.prepareStatement("DELETE FROM usuario WHERE idusuario = ?");
        st.setString(1, idusuario);
        int rowsDeleted = st.executeUpdate();
        if (rowsDeleted > 0) {
            // Registrar no log
            PreparedStatement stLog = conecta.prepareStatement("INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)");
            stLog.setString(1, "usuarios");
            stLog.setString(2, "Excluído o usuário " + usuario); // Nome do usuário capturado
            stLog.setString(3, session.getAttribute("usuario").toString()); // Usuário da sessão
            stLog.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
            stLog.executeUpdate();
            stLog.close();

            response.sendRedirect("usuarios.jsp");
        } else {
            out.println("Erro ao excluir o usuário. Tente novamente.");
        }

        st.close();
        conecta.close();
    } catch (Exception e) {
        out.print("Erro ao excluir usuário: " + e.getMessage());
        e.printStackTrace();
    }
%>
