package br.com.arenaplus.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/public")
public class PublicInfoController {

    @GetMapping("/info")
    public ResponseEntity<Map<String, String>> obterInformacoes() {
        Map<String, String> resposta = Map.of(
                "nome", "Arena+",
                "descricao", "Sistema de Gestão de Competições e Campeonatos Amadores",
                "versaoApi", "v1"
        );

        return ResponseEntity.ok(resposta);
    }
}
