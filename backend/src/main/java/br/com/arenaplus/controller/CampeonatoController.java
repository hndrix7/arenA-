package br.com.arenaplus.controller;

import br.com.arenaplus.dto.CampeonatoRequest;
import br.com.arenaplus.entity.Campeonato;
import br.com.arenaplus.repository.CampeonatoRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/campeonatos")
public class CampeonatoController {

    // TEMPORÁRIO: enquanto não há login, todo campeonato é criado por este usuário.
    // Troque pelo id_usuario do organizador (Passo A).
    private static final Long ID_ORGANIZADOR_DEMO = 1L;

    private final CampeonatoRepository repository;

    public CampeonatoController(CampeonatoRepository repository) {
        this.repository = repository;
    }

    @GetMapping
    public List<Campeonato> listar() {
        return repository.findAll();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Campeonato criar(@Valid @RequestBody CampeonatoRequest req) {
        Campeonato c = new Campeonato();
        c.setIdOrganizador(ID_ORGANIZADOR_DEMO);
        c.setNome(req.nome());
        c.setModalidade(req.modalidade());
        c.setDataInicio(req.dataInicio());
        c.setDataFim(req.dataFim());
        c.setMinEquipes(2);                 // a tela não tem este campo; 2 é o mínimo do banco
        c.setMaxEquipes(req.maxEquipes());
        if (req.status() != null) {
            c.setStatus(req.status());
        }
        return repository.save(c);
    }
}