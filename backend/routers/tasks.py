import asyncio
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import or_
from typing import Optional
from database import get_db
import models
import schemas

router = APIRouter()


def get_task_or_404(task_id: int, db: Session) -> models.Task:
    task = db.query(models.Task).filter(models.Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail=f"Task {task_id} not found")
    return task


@router.get("/tasks", response_model=schemas.TaskListResponse)
def list_tasks(
    search: Optional[str] = Query(None, description="Search by title"),
    status: Optional[schemas.TaskStatus] = Query(None, description="Filter by status"),
    db: Session = Depends(get_db),
):
    query = db.query(models.Task)

    if search:
        query = query.filter(models.Task.title.ilike(f"%{search}%"))

    if status:
        query = query.filter(models.Task.status == status)

    tasks = query.all()
    return {"tasks": tasks, "total": len(tasks)}


@router.get("/tasks/{task_id}", response_model=schemas.TaskResponse)
def get_task(task_id: int, db: Session = Depends(get_db)):
    return get_task_or_404(task_id, db)


@router.post("/tasks", response_model=schemas.TaskResponse, status_code=201)
async def create_task(payload: schemas.TaskCreate, db: Session = Depends(get_db)):
    # Validate blocked_by_id refers to an existing task
    if payload.blocked_by_id is not None:
        get_task_or_404(payload.blocked_by_id, db)

    # Simulate 2-second processing delay (async — does not block the event loop)
    await asyncio.sleep(2)

    task = models.Task(**payload.model_dump())
    db.add(task)
    db.commit()
    db.refresh(task)
    return task


@router.put("/tasks/{task_id}", response_model=schemas.TaskResponse)
async def update_task(
    task_id: int, payload: schemas.TaskUpdate, db: Session = Depends(get_db)
):
    task = get_task_or_404(task_id, db)

    if payload.blocked_by_id is not None:
        if payload.blocked_by_id == task_id:
            raise HTTPException(status_code=400, detail="A task cannot block itself")
        get_task_or_404(payload.blocked_by_id, db)

    # Simulate 2-second processing delay
    await asyncio.sleep(2)

    update_data = payload.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(task, field, value)

    db.commit()
    db.refresh(task)
    return task


@router.delete("/tasks/{task_id}", status_code=204)
def delete_task(task_id: int, db: Session = Depends(get_db)):
    task = get_task_or_404(task_id, db)

    # Clear any tasks that were blocked by this one before deleting
    db.query(models.Task).filter(models.Task.blocked_by_id == task_id).update(
        {"blocked_by_id": None}
    )

    db.delete(task)
    db.commit()
    return None


@router.get("/tasks/search/autocomplete")
def autocomplete_tasks(
    q: str = Query(..., min_length=1, description="Partial title to search"),
    db: Session = Depends(get_db),
):
    """
    Returns task titles matching the query for debounced autocomplete.
    Called after a 300ms debounce on the Flutter side.
    """
    tasks = (
        db.query(models.Task.id, models.Task.title, models.Task.status)
        .filter(models.Task.title.ilike(f"%{q}%"))
        .limit(10)
        .all()
    )
    return [{"id": t.id, "title": t.title, "status": t.status} for t in tasks]
