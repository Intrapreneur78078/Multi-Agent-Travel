# Multi Agent Travel — A Multi-Agent Travel Planner with LangGraph

An open-source AI travel planner that turns a natural-language trip request into a practical travel plan with flight suggestions, hotel ideas, and a day-by-day itinerary. The project uses a multi-agent workflow built with LangGraph, LangChain, and FastAPI.

## Why this project?

Planning a trip usually means jumping between multiple websites, tools, and spreadsheets. This project brings that flow into one experience by combining:

- a flight-search agent,
- a hotel-research agent,
- an itinerary-planning agent, and
- a final response agent,

all coordinated through a LangGraph workflow with PostgreSQL-backed conversation persistence.

## Features

- ✈️ Flight research via a custom flight tool
- 🏨 Hotel suggestions using Tavily search
- 🧠 Multi-agent orchestration with LangGraph
- 📝 Structured travel itinerary generation
- 🌐 FastAPI backend with a simple web interface
- 💾 Conversation state persistence using PostgreSQL (`PostgresSaver` checkpointing)
- ⚡ LLM-powered responses with Groq
- 📊 Optional run tracing via LangSmith
- 🐳 Docker-ready with `uv`-managed dependencies

## Tech Stack

- Python 3.11
- [uv](https://github.com/astral-sh/uv) for dependency management (`pyproject.toml` + `uv.lock`)
- FastAPI
- Jinja2 + HTML/CSS/JavaScript frontend
- LangGraph
- LangChain (`langchain-groq`)
- Groq LLMs
- PostgreSQL (via `psycopg`)
- Tavily API
- Docker

## Project Structure

```text
.
├── src/
│   └── multi_agent_travel/
│       ├── __init__.py
│       ├── app.py            # FastAPI app entry point
│       ├── backend.py        # LangGraph travel workflow
│       ├── test.py           # CLI test script
│       ├── static/           # Static frontend assets
│       ├── templates/        # HTML templates
│       └── tools/            # Flight and web search integrations
├── Dockerfile
├── pyproject.toml
├── uv.lock
├── .python-version
├── .env                       # not committed — see below
└── README.md
```

## Prerequisites

Before running the project locally, make sure you have:

- Python 3.11
- [uv](https://github.com/astral-sh/uv) installed
- PostgreSQL running and accessible (e.g. a free instance on [Render](https://render.com))
- API keys for:
  - Groq
  - Tavily

## Environment Variables

Create a `.env` file in the project root with the following variables:

```env
DATABASE_URL=postgresql://user:password@host:5432/travel_db
GROQ_API_KEY=your_groq_api_key
TAVILY_API_KEY=your_tavily_api_key

# LangSmith tracing
LANGCHAIN_TRACING_V2=true
LANGCHAIN_API_KEY=your_langsmith_api_key
LANGCHAIN_PROJECT=tripmate-ai
```

## Installation

```bash
uv sync
```

This creates a `.venv` and installs everything pinned in `uv.lock`.

## Running the App

From `src/multi_agent_travel/`:

```bash
uv run uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

Then open your browser at:

```text
http://127.0.0.1:8000/
```

You can also run the CLI test script directly:

```bash
uv run python test.py
```

## Running with Docker

Build and run the container:

```bash
docker build -t tripmate-ai .
docker run --env-file .env -p 8000:8000 tripmate-ai
```

## API Endpoints

- `GET /health` - Health check
- `POST /api/travel` - Submit a travel request

Example request:

```bash
curl -X POST http://127.0.0.1:8000/api/travel \
  -H "Content-Type: application/json" \
  -d '{"message":"Plan a 3-day trip to Tokyo with a budget of $1200"}'
```

## How the Workflow Works

1. The user submits a travel request.
2. The **flight agent** gathers flight-related information.
3. The **hotel agent** searches for accommodation suggestions via Tavily.
4. The **itinerary agent** creates a practical, budget-aware day-by-day plan.
5. The **final agent** formats everything into a polished, structured response.
6. State is checkpointed to PostgreSQL at each step, enabling multi-turn conversations tied to a `thread_id`.

## Contributing

Contributions are welcome. If you want to improve the app, add new travel features, or fix issues:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Open a pull request

## Acknowledgments

This project is built with the help of modern LLM tooling and travel APIs, and it is intended as a practical example of combining LangGraph agents with real-world applications.