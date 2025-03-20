<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
    String usuario = request.getParameter("usuario");
    String senha = request.getParameter("senha");

    try {
        // Conectar ao banco de dados
        Connection conecta;
        PreparedStatement st;
        Class.forName("com.mysql.cj.jdbc.Driver");
        conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");

        // Verificar as credenciais do usu�rio
        st = conecta.prepareStatement("SELECT idusuario, idperfil FROM usuario WHERE usuario=? AND senha=?");
        st.setString(1, usuario);
        st.setString(2, senha);
        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            int idPerfil = rs.getInt("idperfil");

            // Obter as telas de acesso do perfil
            st = conecta.prepareStatement("SELECT telasdeacesso FROM perfil WHERE idperfil=?");
            st.setInt(1, idPerfil);
            ResultSet rsPerfil = st.executeQuery();

            if (rsPerfil.next()) {
                String telasDeAcesso = rsPerfil.getString("telasdeacesso");
                List<String> telas = new ArrayList<>();
                for (String tela : telasDeAcesso.split(",")) {
                    telas.add(tela.trim());
                }

                session.setAttribute("usuario", usuario);
                session.setAttribute("telas", telas);
                response.sendRedirect("login.jsp");
            } else {
                out.println("Perfil n�o encontrado.");
            }
        } else {
            out.println("Usu�rio ou senha inv�lidos.");
        }

        // Fechar a conex�o
        st.close();
        conecta.close();
    } catch (Exception e) {
        out.print("Erro na transmiss�o para o mySQL: " + e.getMessage());
        e.printStackTrace();
    }
%>
