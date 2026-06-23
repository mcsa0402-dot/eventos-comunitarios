package main;

import view.TelaCadastroUsuario;
import view.TelaCadastroEvento;
import view.TelaInscricao;
import view.TelaRelatorio;

import javax.swing.*;

public class Main {

    public static void main(String[] args) {

        JFrame menu = new JFrame("Sistema de Eventos");
        menu.setSize(350, 350);
        menu.setLayout(null);
        menu.setLocationRelativeTo(null);
        menu.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // BOTÕES
        JButton btnUsuario = new JButton("Cadastrar Usuário");
        JButton btnEvento = new JButton("Cadastrar Evento");
        JButton btnInscricao = new JButton("Inscrição");
        JButton btnRelatorio = new JButton("Relatório");

        // POSIÇÕES
        btnUsuario.setBounds(60, 40, 200, 30);
        btnEvento.setBounds(60, 90, 200, 30);
        btnInscricao.setBounds(60, 140, 200, 30);
        btnRelatorio.setBounds(60, 190, 200, 30);

        // ADICIONAR À TELA
        menu.add(btnUsuario);
        menu.add(btnEvento);
        menu.add(btnInscricao);
        menu.add(btnRelatorio);

        // AÇÕES
        btnUsuario.addActionListener(e -> new TelaCadastroUsuario().setVisible(true));
        btnEvento.addActionListener(e -> new TelaCadastroEvento().setVisible(true));
        btnInscricao.addActionListener(e -> new TelaInscricao().setVisible(true));
        btnRelatorio.addActionListener(e -> new TelaRelatorio().setVisible(true));

        // EXIBIR MENU
        menu.setVisible(true);
    }
}