<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.util.Base64"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%
    String idusuario = request.getParameter("idusuario");
    String usuario = request.getParameter("usuario");
    String senha = request.getParameter("senha");
    String perfil = request.getParameter("perfil");

    try {
        // Conectar ao banco de dados
        Connection conecta;
        PreparedStatement st;
        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

        // Verificar o ID do perfil
        PreparedStatement stPerfil = conecta.prepareStatement("SELECT idperfil FROM perfil WHERE perfil = ?");
        stPerfil.setString(1, perfil);
        ResultSet rsPerfil = stPerfil.executeQuery();
        int idperfil = 0;
        if (rsPerfil.next()) {
            idperfil = rsPerfil.getInt("idperfil");
        }

        // Gerar o hash da senha utilizando SHA-256
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(senha.getBytes("UTF-8"));
        String senhaHash = Base64.getEncoder().encodeToString(hashBytes);

        // Atualizar o usuário no banco de dados
        st = conecta.prepareStatement("UPDATE usuario SET usuario = ?, senha = ?, perfil = ?, idperfil = ? WHERE idusuario = ?");
        st.setString(1, usuario);
        st.setString(2, senhaHash);
        st.setString(3, perfil);
        st.setInt(4, idperfil);
        st.setString(5, idusuario);

        int rowsUpdated = st.executeUpdate();
        if (rowsUpdated > 0) {
            // Registrar no log
            PreparedStatement stLog = conecta.prepareStatement("INSERT INTO logs (tela, acao, usuario, datahoralog) VALUES (?, ?, ?, ?)");
            stLog.setString(1, "usuarios");
            stLog.setString(2, "Editado o usuário " + usuario);
            stLog.setString(3, session.getAttribute("usuario").toString());
            stLog.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
            stLog.executeUpdate();
            stLog.close();

            response.sendRedirect("usuarios.jsp");
        } else {
            out.println("Erro ao atualizar o usuário. Tente novamente.");
        }

        st.close();
        rsPerfil.close();
        stPerfil.close();
        conecta.close();
    } catch (Exception e) {
        out.print("Erro ao atualizar usuário: " + e.getMessage());
        e.printStackTrace();
    }
%>
