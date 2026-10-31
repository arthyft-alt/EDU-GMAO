# GMAO Brisson

GMAO (Gestion de la Maintenance Assistée par Ordinateur) pédagogique et opérationnelle de la section BTS Maintenance des Systèmes du lycée Henri Brisson (Vierzon).

**Version 1.0** (29/10/2026). La version installée s'affiche en bas de l'écran et dans `/api/health`.

- **Back** : Python / Flask (`backend/`), base SQLite en local, MySQL en production.
- **Front** : React / Vite (`frontend/`).
- **Hébergement** : cPanel (Passenger pour l'API, fichiers statiques pour l'affichage).

## Démarrage rapide (Windows)

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1   # installation (première fois et après une mise à jour)
powershell -ExecutionPolicy Bypass -File .\dev.ps1     # lancement : http://localhost:5173
```

Comptes de démonstration (local uniquement) : `admin/admin`, `tech/tech`, `tech2/tech2`, `operateur/operateur`.

## Documentation

| Fichier | Contenu |
|---|---|
| Menu **Aide** de l'application | Documentation utilisateur par profil (opérateur, élève, enseignant) et guide d'administration (rentrée, changement de classe, sauvegardes, 1er août) |
| [PLAN.md](PLAN.md) | Avancement du projet et décisions |
| [cahier-des-charges.md](cahier-des-charges.md) | Exigences fonctionnelles |
| [04-tester-sur-son-pc.md](04-tester-sur-son-pc.md) | Lancer et tester sur son PC |
| [05-mise-en-ligne-cpanel.md](05-mise-en-ligne-cpanel.md) | Mise en ligne sur cPanel |

## Tests

```powershell
cd backend; .\.venv\Scripts\python -m pytest     # tests du serveur
cd frontend; npm run build                        # vérifie que l'affichage compile
```
