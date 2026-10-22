# NovaBank Core — Administration PostgreSQL

Déploiement et sécurisation du prototype de base de données pour la banque en ligne NovaBank.

## Structure des scripts (`sql/`)

1. `schema.sql` : Création des schémas `core` et `audit`, des 6 tables (`customers`, `accounts`, `transfers`, `transactions`, `fraud_alerts`, `audit_log`) et des contraintes d'intégrité (soldes, IBAN, emails).
2. `securite.sql` : Configuration RBAC avec 4 profils (`analyste`, `support`, `appli`, `auditeur`) et accès restreints.
3. `data.sql` : Génération du jeu de données (dont 1 000 000 d'écritures pour tests de charge).
4. `views.sql` : Création des vues anonymisées et matérialisées.
5. `index.sql` : Indexation des colonnes stratégiques et optimisation des recherches.
6. `triggers.sql` : Mise à jour automatique des soldes, immutabilité du grand livre, détection des fraudes et journalisation d'audit.
7. `procedures.sql` : Procédures stockées pour l'exécution atomique des virements (transactions ACID) et l'ouverture de comptes.
8. `tests.sql` : Scripts d'acceptation et de vérification des politiques de sécurité.

---

## Déploiement automatisé (VM Debian)

Exécuter la chaîne complète de déploiement en tant qu'utilisateur `postgres` :

```bash
cp sql/*.sql /tmp/ && chmod 777 /tmp/*.sql
su - postgres -c "psql -d novabank -f /tmp/schema.sql -f /tmp/securite.sql -f /tmp/data.sql -f /tmp/views.sql -f /tmp/index.sql -f /tmp/triggers.sql -f /tmp/procedures.sql -f /tmp/tests.sql"