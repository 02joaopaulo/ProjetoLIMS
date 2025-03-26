<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Análise de Umidade</title>
    <link rel="stylesheet" href="css/usuario.css"/>
    <script>
        function calcularumidade() {
            const massarecipiente = parseFloat(document.getElementById("massarecipiente").value);
            const massaumida = parseFloat(document.getElementById("massaumida").value);
            const massaseca = parseFloat(document.getElementById("massaseca").value);

            if (!isNaN(massarecipiente) && !isNaN(massaumida) && !isNaN(massaseca)) {
                const umidade = ((massaumida - massaseca) / (massaumida - massarecipiente)) * 100;
                document.getElementById("umidade").textContent = umidade.toFixed(2) + "%";
                document.getElementById("btnSalvar").disabled = false;
            } else {
                alert("Por favor, preencha todos os campos de massa.");
            }
        }
    </script>
</head>
<body>
    <div class="form-container">
        <div class="form-box">
            <form method="post" action="salvar_analise_umidade.jsp">
                <h2>Identificação:</h2>
                <label for="idamostra">ID Amostra:</label>
                <input type="text" name="idamostra" id="idamostra" value="<%= request.getParameter("idamostra") %>" readonly>
                
                <h2>Dados de Entrada:</h2>
                <label for="massarecipiente">Massa do Recipiente:</label>
                <input type="number" name="massarecipiente" id="massarecipiente" step="0.01" required>
                
                <label for="massaumida">Massa Úmida:</label>
                <input type="number" name="massaumida" id="massaumida" step="0.01" required>
                
                <label for="massaseca">Massa Seca:</label>
                <input type="number" name="massaseca" id="massaseca" step="0.01" required>
                
                <button type="button" onclick="calcularumidade()">Calcular</button>
                
                <h2>Resultados:</h2>
                <p>Umidade: <span id="umidade">0.00%</span></p>
                
                <h2>Liberação:</h2>
                <label for="responsavelanalise">Responsável pela Análise:</label>
                <select name="responsavelanalise" id="responsavelanalise" required>
                    <%
                        Connection conecta = null;
                        PreparedStatement st = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conecta = DriverManager.getConnection("jdbc:mysql://localhost:3306/projeto_lims", "root", "joao.santos");
                            st = conecta.prepareStatement("SELECT usuario FROM usuario WHERE perfil = 'analista'");
                            rs = st.executeQuery();
                            while (rs.next()) {
                                String usuario = rs.getString("usuario");
                    %>
                    <option value="<%= usuario %>"><%= usuario %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.print("Erro ao consultar usuários: " + e.getMessage());
                            e.printStackTrace();
                        } finally {
                            if (rs != null) rs.close();
                            if (st != null) st.close();
                            if (conecta != null) conecta.close();
                        }
                    %>
                </select>
                
                <button type="submit" id="btnSalvar" disabled>Salvar</button>
            </form>
        </div>
    </div>
</body>
</html>
