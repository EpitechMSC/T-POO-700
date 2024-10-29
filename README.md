# T-POO-700

##### V1.0.0

Welcome to Gotham City Services, a project created as part of the MSC Epitech Nantes.

This project, immersed in the dark and fascinating world of Gotham, aims to address the logistical challenges of the forces of order (and other masked vigilantes).

The goal? To create a work schedule and shift management application for the Gotham police officers, who never get a moment’s rest facing the city’s perpetual chaos.

In the dark and complex world of Gotham, where order and chaos coexist, this project aims to manage the schedules of the forces of order.

Between day and night shifts and on-call periods, our application will allow you to track teams of vigilantes on duty.

Used by heroes, this project is essential to maintaining order in Gotham… or at least trying to.

Whether you are a simple police officer or a masked vigilante, our solution helps you stay organized in the fight against crime.

---

---

**Main Features**:

- Work schedule management:

  The application primarily allows the logging of work hours for each employee, police officer, and vigilante.

  The application also allows effective team planning while trying to respect legal quotas and the tough working conditions in Gotham.

  Some situations require police officers to remain on alert, ready to intervene.

  Night shifts and overtime are increased.

- User management:

  The system allows for the addition, modification, and complete management of users and their roles.

  Each vigilante or police officer has a well-defined role!

- Statistics and data visualization:

  With the integration of various charts, it is possible to monitor performance and analyze attendance and efficiency statistics.

- Mobile optimization with Cordova:

  The project is designed to be usable on both desktop and mobile, thanks to Cordova, so even in the field, each hero can access their schedule.

**Technologies used**:

- Backend:

  [Elixir](https://elixir-lang.org/) and [Phoenix](https://www.phoenixframework.org/)

- Frontend:

  [Vue.js](https://vuejs.org/)

- Database:

  [PostgreSQL](https://www.postgresql.org/)

- Docker & Kubernetes

- CI/CD and monitoring:

  Grafana 🕓 and SonarQube.

---

---

## 🏁 Installation

### Prerequisites

Before starting, make sure the following are installed on your machine:

- Node.js (version 16.15.1 or higher)

- Elixir and Phoenix (version 1.17.3 (compiled with Erlang/OTP 26) or higher)

- PostgreSQL

### Installation steps

Clone this repository to your local machine:

```bash
git clone https://github.com/EpitechMSC/T-POO-700.git
cd T-POO-700
```

#### Install dependencies:

**Frontend**:

```bash
npm install # or yarn install
```

**Backend**:

```bash
mix deps.get
```

**Set up the PostgreSQL database**:

Create a database and configure the `config/dev.exs` file with your connection details.

Then run the following commands to create and migrate the database:

```bash
mix ecto.create
mix ecto.migrate
```

Run the seeds to populate the database:

```bash
mix run priv/repo/seeds.exs
```

## ⚙️ Configuration

Before using the application, make sure to configure the following:

Modify the `config/dev.exs` file to adjust the project’s settings, such as database information and port configurations.

To ensure the project is functioning correctly, you can run tests for the backend.

1. Make sure your dependencies and database are set up:
    ```bash
    mix deps.get
    mix ecto.setup
    ```

2. Run the tests:
    ```bash
    mix test
    ```

## 🔧 Usage

Launch the _backend server_:

Start the **Phoenix** server:

```bash
mix phx.server
```

The server will be available at http://localhost:4000.

Launch the _frontend server_:

Start the **frontend** application:

```bash
npm run dev
```

The application will be accessible at http://127.0.0.1:5173/.

---

### 📱 Mobile Build and Development

To build for mobile and deploy on an emulator or Android device:

1. Navigate to the `frontend` folder and run:

    ```bash
    npm run build:mobile
    ```

2. Then, navigate to the `mobile` folder and run:

    ```bash
    cordova run android
    ```

   This command connects the build to your emulator or Android device for testing.

To develop for mobile with a local backend, start the backend server and update `.env.mobile` in the frontend folder with your machine’s IP address to ensure it points to your local setup. By default, it will connect to the production server.

---

## 🐙 Contributions

Contributions are welcome!

Follow these steps to contribute to the project:

- Fork this repository.

- Create a dedicated branch for your modification:

```bash
git checkout -b feat/<new-feature>
```

Or

```bash
git checkout -b fix/<feature>
```

- Make your changes, then run:

```bash
~/backend mix format
```

- Commit your changes:

```bash
git commit -m "---"
```

- Push your branch:

```bash
git push origin <your-branch>
```

- Open a Pull Request on the main repository.
  <br>✨

## 📚 Project Management

**Project Management Documents**
<br>All documents related to project management, such as technical specifications and user stories, are organized and accessible at [this address]([https://t.ly/9qPXD](https://epitechfr-my.sharepoint.com/:x:/r/personal/gaetan_pecqueux_epitech_eu/Documents/POO-700/USER%20STORY.xlsx?d=w15e211d5163348aa9766fac05c952cbf&csf=1&web=1&e=zqac0S)).

**Jira**
<br>We use Jira to manage tasks, user stories, and bugs.
<br>You can check the Jira board to follow tasks in progress, assigned, or completed.
<br>Jira is available at [this address]([https://t.ly/Z-HCg](https://michess.atlassian.net/jira/software/projects/TM/boards/34)).

**Communication**
<br>All external communication materials, such as posters, and any other visual communication material for promoting the project, are stored at [this address]([https://t.ly/Aw8h-](https://epitechfr-my.sharepoint.com/:f:/r/personal/gaetan_pecqueux_epitech_eu/Documents/POO-700/IMG?csf=1&web=1&e=534T88)).

**Figma**
<br>We use Figma for designing user interfaces and collaborating on design.
<br>Mockups, interactive prototypes, and designs are shared in our Figma workspace, available at [this address]([https://t.ly/xyFaz](https://www.figma.com/design/WZ3zAUXBP7L1yQaXWcPhdW/WorkingTimes-Figma?node-id=0-1&t=SCivI4OEmp2uq4sE-1)).

## 📜 License

This project is under the [MIT License](https://fr.wikipedia.org/wiki/Licence_MIT).
