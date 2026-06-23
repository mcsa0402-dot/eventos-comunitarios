package view;

import connection.ConnectionFactory;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TelaRelatorio extends JFrame {

    public TelaRelatorio() {

        setTitle("Relatório de Inscrições");
        setSize(600, 400);
        setLocationRelativeTo(null);

        String[] colunas = {"Participante", "Evento", "Status"};
        DefaultTableModel model = new DefaultTableModel(colunas, 0);

        JTable tabela = new JTable(model);

        carregarDados(model);

        add(new JScrollPane(tabela));
    }

    private void carregarDados(DefaultTableModel model) {

        try (Connection conn = ConnectionFactory.getConnection();
             Statement stmt = conn.createStatement()) {

            String sql = "SELECT u.nome, e.titulo, i.status " +
                         "FROM inscricao i " +
                         "JOIN usuario u ON i.id_usuario = u.id_usuario " +
                         "JOIN evento e ON i.id_evento = e.id_evento";

            ResultSet rs = stmt.executeQuery(sql);

            while (rs.next()) {
                model.addRow(new Object[]{
                        rs.getString("nome"),
                        rs.getString("titulo"),
                        rs.getString("status")
                });
            }

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e.getMessage());
        }
    }
}