# Nextcloud pour Windows ARM64

Client de bureau [Nextcloud](https://github.com/nextcloud/desktop) compilé **nativement pour Windows 11 ARM64**
(Snapdragon X, Surface Pro, etc.), à partir du code source officiel, sans émulation x64.

> Build communautaire non officiel, sans lien avec Nextcloud GmbH.

## Télécharger

Dernière version : onglet **[Releases](../../releases)**.

| Fichier | Usage |
|---|---|
| `Nextcloud-<version>-arm64-setup.exe` | Installateur (recommandé) |
| `Nextcloud-<version>-arm64-portable.zip` | Version sans installation |
| `SHA256SUMS.txt` | Empreintes pour vérifier les fichiers |

L'installateur n'est pas signé : Windows SmartScreen affichera un avertissement.
Cliquez sur **Informations complémentaires**, puis **Exécuter quand même**.

Installation silencieuse (déploiement) :

```powershell
.\Nextcloud-35.0.3-arm64-setup.exe /VERYSILENT /TASKS="shellext,autostart"
```

## Différences avec le client officiel

- **Mise à jour automatique désactivée** : l'updater officiel installerait la version x64.
  Relancez le workflow (ou téléchargez la nouvelle Release) à chaque nouvelle version.
- Installateur Inno Setup au lieu du MSI officiel.
- Pas de signature de code.

Tout le reste (fichiers virtuels Windows, intégration à l'Explorateur, chiffrement de bout en bout,
connexion via le navigateur `nc://`) provient du code source officiel, sans modification.

## Compiler une nouvelle version

1. Onglet **Actions** > **Build Nextcloud Windows ARM64** > **Run workflow**.
2. Indiquez le tag Nextcloud (ex. `v35.0.4`, voir les [releases officielles](https://github.com/nextcloud/desktop/releases)).
3. Le build tourne sur une machine GitHub Windows 11 ARM64 (gratuite pour les dépôts publics).
   Comptez environ 1 h 30 la première fois, beaucoup moins ensuite grâce au cache.
4. L'installateur est publié dans les Releases (et disponible dans les artefacts du run).

### Chaîne de compilation

| Composant | Source |
|---|---|
| Qt 6 (MSVC 2022 ARM64) | binaires officiels Qt via `aqtinstall` |
| OpenSSL, zlib, SQLite, pkgconf | `vcpkg` (triplet `arm64-windows`) |
| extra-cmake-modules, KArchive | sources KDE Frameworks |
| QtKeychain, KDSingleApplication, libp11 | sources des projets |
| Client Nextcloud | `github.com/nextcloud/desktop` au tag choisi |
| Installateur | Inno Setup |

Les versions sont définies en tête de `.github/workflows/build.yml`.
`tools/icotool.py` remplace l'outil `icotool` (icoutils), introuvable sous Windows ARM64, pour générer l'icône `.ico`.

## Licence

Le client Nextcloud est distribué sous licence GPL-2.0-or-later ; voir `COPYING.txt` dans le paquet
et le [code source officiel](https://github.com/nextcloud/desktop).
Les scripts de ce dépôt sont sous la même licence.
