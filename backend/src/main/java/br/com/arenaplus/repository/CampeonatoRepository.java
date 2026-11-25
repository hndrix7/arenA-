package br.com.arenaplus.repository;

import br.com.arenaplus.entity.Campeonato;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CampeonatoRepository extends JpaRepository<Campeonato, Long> {
}